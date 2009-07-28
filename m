Return-Path: <linux-kernel-owner+w=401wt.eu-S1751469AbZG1HgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbZG1HgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZG1HgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:36:06 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:55235 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZG1HgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=hWR48Hl883MqpGPPbePMiQFHBCVO8P92xb+u1w++ijJus35MQiSnf5hR/nfl1aL9hP
         lSwmwDVopK1n9l7P5/GHlQXdiMifAnBrCGqdkmy+xNUa9tj2Muyl960gLFgowHLVDKbT
         VY5tk8CP8lf9qNr3ytTFDrH6lRgxXij/4k8ug=
Date: Tue, 28 Jul 2009 00:36:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch RFC 02/37] input: keyboard/hil_kbd: semaphore cleanup
References: <20090726081459.455111897@linutronix.de> <20090726081553.506979599@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090726081553.506979599@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090728080951.D0AE2526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 08:17:15AM -0000, Thomas Gleixner wrote:
> The usage of this "mutex" is non obvious and probably a completion in
> some places. Make it a semaphore.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> ---
>  drivers/input/keyboard/hil_kbd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-tip/drivers/input/keyboard/hil_kbd.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/input/keyboard/hil_kbd.c
> +++ linux-2.6-tip/drivers/input/keyboard/hil_kbd.c
> @@ -277,7 +277,7 @@ static int hil_kbd_connect(struct serio 
>  	serio_set_drvdata(serio, kbd);
>  	kbd->serio = serio;
>  
> -	init_MUTEX_LOCKED(&kbd->sem);
> +	semaphore_init_locked(&kbd->sem);
>  

I started working on conversion of that into a completion, I'll
commit as soon as I get someone to test it.

-- 
Dmitry
