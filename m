Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbYLDBPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbYLDBPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYLDBP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:15:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48949 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYLDBPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:15:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #12162] Commit 7cd5b08be3 breaks startup on Toshiba Portege R500
Date: Thu, 4 Dec 2008 02:12:59 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>, Wim Van Sebroeck <wim@iguana.be>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera> <bfPM5B8Tx2B.A.bmG.moxNJB@chimera> <alpine.LFD.2.00.0812031632420.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812031632420.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812040213.00374.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 4 of December 2008, Linus Torvalds wrote:
> 
> Rafael, I'm assuming my one-liner patch fixes your problem too, since you 
> attached the patch to the bugzilla entry. So I committed it as such. But 
> if it doesn't, we'll need to do something else.
> 
> The commit ended up being as appended..

I've just pulled your tree including this commit and it boots correctly, so
this is the right fix.

I've already closed the bug.

Thanks,
Rafael


> ---
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 3 Dec 2008 16:20:19 -0800
> Subject: [PATCH] iTCO_wdt: fix typo when setting TCO_EN bit
> 
> The code used '&= 0x00002000' when it tried to set the TCO_EN bit, which
> obviously didn't set that bit at all, but instead just reset all the
> other bits in the SMI_EN register.
> 
> This bug seemingly caused various random behavior, with Frans Pop
> reporting that X.org just silently hung at startup and Rafael Wysocki
> reports the fan spinning with full speed.
> 
> See
> 	http://lkml.org/lkml/2008/12/3/178
> 	http://bugzilla.kernel.org/show_bug.cgi?id=12162
> 
> The problem seems to have been triggered by "[WATCHDOG] iTCO_wdt :
> problem with rebooting on new ICH9 based motherboards" (commit
> 7cd5b08be3c489df11b559fef210b81133764ad4), but the bogus code existed
> before that too (in the "supermicro_old_pre_stop()" function), it just
> apparently never showed up due to different logic.
> 
> In that commit the broken code got moved around and now gets executed
> much more.
> 
> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
> Tested-by: Frans Pop <elendil@planet.nl>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/watchdog/iTCO_wdt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
> index 26173a2..5b395a4 100644
> --- a/drivers/watchdog/iTCO_wdt.c
> +++ b/drivers/watchdog/iTCO_wdt.c
> @@ -392,7 +392,7 @@ static int iTCO_wdt_stop(void)
>  
>  	/* Bit 13: TCO_EN -> 1 = Enables the TCO logic to generate SMI# */
>  	val32 = inl(SMI_EN);
> -	val32 &= 0x00002000;
> +	val32 |= 0x00002000;
>  	outl(val32, SMI_EN);
>  
>  	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
> 
> 



-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
