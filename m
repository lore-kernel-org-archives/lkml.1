Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYG3HvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYG3HvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYG3HvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:51:08 -0400
Received: from 1wt.eu ([62.212.114.60]:2271 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYG3HvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:51:07 -0400
Date: Wed, 30 Jul 2008 09:51:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: David W Studeman <avionicsdv@aim.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Keyboard Jammed error patch 2.4.35-pre4
Message-ID: <20080730075101.GA31668@1wt.eu>
References: <g6jqud$t5e$1@ger.gmane.org> <20080729051558.GH29189@1wt.eu> <489016AB.6050309@aim.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489016AB.6050309@aim.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 12:22:19AM -0700, David W Studeman wrote:
> No I can't use the nokeybd option as a Cobalt uses no bootloader on the 
> mbr. The arguments would have to be embedded into the flashrom image and 
> it isn't something most people want to deal with.

OK, I was not talking about a solution but about a temporary workaround
anyway :-)

> >Also, if you don't have any PC keyboard on your machines, you can
> >build without support for any VT/keyboard. I'm already doing this
> >on some embedded systems, and it works fine. If your platform still
> >requires that some keyboard is enabled, you may want to try to enable
> >CONFIG_DUMMY_KEYB which I've been using in the past.
> >   
> That didn't work either, what did save me was patching back to 2.4.34 
> for the dmi and keyboard headers and compiling without any keyboard 
> support at all. Also, since this is essentially a PC without a normal 
> bios, the kernel reports that there is no dmi present. The boot method 
> here reminds me of EFI but it isn't.

Just so that I understand, when you say it is a PC, is it x86-based or
a different arch ? I thought it was a mips, but now you're speaking about
a PC I'm confused. If it's x86, I don't see why the patch caused a regression
since it does not change the default behaviour for x86. If it's a mips, I don't
see why the proposed patch does not work as it was supposed to revert to
previous behaviour :-/

> >@@ -905,7 +908,7 @@ static char * __init initialize_kbd(void)
> >
> >  void __init pckbd_init_hw(void)
> >  {
> >-   if (!keyboard_controller_present) {
> >+   if (!kbd_controller_present()) {
> >         kbd_exists = 0;
> >         return;
> >     }
> >   
> The last hunk at 905 fails to apply, line 61 passes due to some fuzz 
> factor although I can't see what is different and why it needs to fuzz 
> but line 61 still passes. Here is a snip from the log:

hmm sorry, I did it in a hurry against next 2.4.37-rc1. I'll check.

> patching file drivers/char/pc_keyb.c
> Hunk #1 succeeded at 61 with fuzz 1.
> Hunk #4 FAILED at 908.
> 1 out of 4 hunks FAILED -- saving rejects to file drivers/char/pc_keyb.c.rej
> make: *** [/usr/src/log/linux-2.4.36.6] Error 1
> 
> And here is the pc_keyb.c.rej:
> 
> ***************
> *** 905,911 ****
> 
>   void __init pckbd_init_hw(void)
>   {
> -    if (!keyboard_controller_present) {
>          kbd_exists = 0;
>          return;
>      }
> --- 908,914 ----
> 
>   void __init pckbd_init_hw(void)
>   {
> +    if (!kbd_controller_present()) {
>          kbd_exists = 0;
>          return;
>      }

This was the important part. Did you fix it by hand ? If not, it would
explain why it did not change the behaviour.

Regards,
Willy

