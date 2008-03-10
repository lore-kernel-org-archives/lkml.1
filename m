Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYCJTyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYCJTyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYCJTyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:54:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbYCJTyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:54:06 -0400
Date: Mon, 10 Mar 2008 20:53:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Phil Oester <kernel@linuxace.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc5: WARNING: at arch/x86/mm/ioremap.c
Message-ID: <20080310195346.GA3305@elte.hu>
References: <20080310194022.GA1764@linuxace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310194022.GA1764@linuxace.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Phil Oester <kernel@linuxace.com> wrote:

> Still getting the 'WARNING: at arch/x86/mm/ioremap.c:137 
> __ioremap+0xb1/0x165()' error in -rc5.  Seen a few threads on this 
> error, but apparently still not resolved.  Anyone need more info?

the warning is harmless and will be removed in the next x86 update. 
(patch is queued up in x86.git already, see below.)

	Ingo

-------------->
Subject: x86: ioremap, remove WARN_ON()
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Feb 26 09:30:32 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-x86.q/arch/x86/mm/ioremap.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/ioremap.c
+++ linux-x86.q/arch/x86/mm/ioremap.c
@@ -134,8 +134,6 @@ static void __iomem *__ioremap(unsigned 
 			return NULL;
 	}
 
-	WARN_ON_ONCE(page_is_ram(pfn));
-
 	switch (mode) {
 	case IOR_MODE_UNCACHED:
 	default:
