Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbYLCWSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbYLCWSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbYLCWR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:17:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255AbYLCWR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:17:56 -0500
Date: Wed, 3 Dec 2008 14:17:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Wim Van Sebroeck <wim@iguana.be>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression from 2.6.28-rc7: Commit 7cd5b08be3 breaks startup on
 Toshiba Portege R500
In-Reply-To: <200812032300.19110.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812031412060.3256@nehalem.linux-foundation.org>
References: <200812032300.19110.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Dec 2008, Rafael J. Wysocki wrote:
> 
> commit 7cd5b08be3c489df11b559fef210b81133764ad4
> Author: Wim Van Sebroeck <wim@iguana.be>
> Date:   Wed Nov 19 19:39:58 2008 +0000
> 
>     [WATCHDOG] iTCO_wdt : problem with rebooting on new ICH9 based motherboards
> 
>     Bugzilla #9868: On Intel motherboards with the ICH9 based I/O controllers
>     (Like DP35DP and DG33FB) the iTCO timer counts but it doesn't reboot the
>     system after the counter expires.
> 
>     This patch fixes this by moving the enabling & disabling of the TCO_EN bit
>     in the SMI_EN register into the start and stop code.
> 
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> makes CPU fan spin with full speed and causes hald-addon-acpi to take 100% of
> CPU time on Toshiba Portege R500 with openSUSE 11.0 user space.  This starts as
> soon as hal starts or thereabouts and never ends, which makes the current
> mainline unusable on that box.

Hmm. I wonder if the bug is this one-liner (it really looks like an 
idiotic typo).

Can you test?

		Linus
---
 drivers/watchdog/iTCO_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 26173a2..5b395a4 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -392,7 +392,7 @@ static int iTCO_wdt_stop(void)
 
 	/* Bit 13: TCO_EN -> 1 = Enables the TCO logic to generate SMI# */
 	val32 = inl(SMI_EN);
-	val32 &= 0x00002000;
+	val32 |= 0x00002000;
 	outl(val32, SMI_EN);
 
 	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
