Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYLCXNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYLCXNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYLCXNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:13:37 -0500
Received: from hpsmtp-eml15.KPNXCHANGE.COM ([213.75.38.115]:35000 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203AbYLCXNg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:13:36 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.28-rc7: Commit 7cd5b08be3 breaks startup on Toshiba Portege R500
Date: Thu, 4 Dec 2008 00:13:32 +0100
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, wim@iguana.be, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <200812032300.19110.rjw@sisk.pl> <200812032300.19110.rjw@sisk.pl> <alpine.LFD.2.00.0812031412060.3256@nehalem.linux-foundation.org>
In-reply-To: <alpine.LFD.2.00.0812031412060.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812040013.34009.elendil@planet.nl>
X-OriginalArrivalTime: 03 Dec 2008 23:13:34.0422 (UTC) FILETIME=[C3C0C760:01C9559C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm. I wonder if the bug is this one-liner (it really looks like an
> idiotic typo).
>
> Can you test?
>
>  drivers/watchdog/iTCO_wdt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
> index 26173a2..5b395a4 100644
> --- a/drivers/watchdog/iTCO_wdt.c
> +++ b/drivers/watchdog/iTCO_wdt.c
> @@ -392,7 +392,7 @@ static int iTCO_wdt_stop(void)
>  
>         /* Bit 13: TCO_EN -> 1 = Enables the TCO logic to generate SMI#
> */ val32 = inl(SMI_EN);
> -       val32 &= 0x00002000;
> +       val32 |= 0x00002000;
>         outl(val32, SMI_EN);
>  
>         /* Set the NO_REBOOT bit to prevent later reboots, just for
> sure */

Fixes my X.Org issue (http://lkml.org/lkml/2008/12/3/178).

Cheers,
FJP
