Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXCYFPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXCYFPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 01:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXCYFPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 01:15:04 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:24706 "EHLO
	asav04.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219AbXCYFPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 01:15:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAKqiBUZKhRO4dGdsb2JhbACPYQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: keyboard.c: Stop flooding dmesg with useless warnings
Date: Sun, 25 Mar 2007 01:15:01 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
References: <Pine.LNX.4.64.0703242315160.492@paragw-desktop> <Pine.LNX.4.64.0703242333290.492@paragw-desktop>
In-Reply-To: <Pine.LNX.4.64.0703242333290.492@paragw-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703250115.02029.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 March 2007 23:38, Parag Warudkar wrote:
> 
> >
> > Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
> >
> > --- linux-2.6-wk/drivers/char/keyboard.c	2007-03-24 23:01:19.000000000 
> > -0400
> > +++ linux-2.6/drivers/char/keyboard.c	2007-03-24 21:43:58.000000000 -0400
> > @@ -1161,7 +1161,7 @@
> >
> > 	if ((raw_mode = (kbd->kbdmode == VC_RAW)) && !hw_raw)
> > 		if (emulate_raw(vc, keycode, !down << 7))
> > -			if (keycode < BTN_MISC && keycode != KEY_RESERVED)
> > +			if (keycode < BTN_MISC)
> > 				printk(KERN_WARNING "keyboard.c: can't 
> > emulate rawmode for keycode %d\n", keycode);
> >
> > #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
> >
> 
> Yikes. Wrong one above. Right one below. Against latest git.
> 
> I use  Apple keyboard and mouse which seem to generate events with
> keycode==0.
> 
> keyboard.c floods dmesg endlessly with below messages. This happens at a
> very fast rate and never stops, leaving the dmesg unusable.
> 
> [46591.960000] keyboard.c: can't emulate rawmode for keycode 0
> [46591.996000] keyboard.c: can't emulate rawmode for keycode 0
> [46592.032000] keyboard.c: can't emulate rawmode for keycode 0
> [46592.068000] keyboard.c: can't emulate rawmode for keycode 0
> [46592.104000] keyboard.c: can't emulate rawmode for keycode 0
> [46592.140000] keyboard.c: can't emulate rawmode for keycode 0
> [46592.176000] keyboard.c: can't emulate rawmode for keycode 0
> [46592.212000] keyboard.c: can't emulate rawmode for keycode 0
> [46592.248000] keyboard.c: can't emulate rawmode for keycode 0
> 
> The patch below avoids printing the warning if keycode == KEY_RESERVED.
> 
> If a more correct fix is possible please let me know and I will redo this.
> (I suspect avoiding call to emulate_raw() with value ranges it cannot
> emulate might be a better fix?)

Actually the keyboard driver should not emit input events for that key code.
Is this a USB keyboard?

-- 
Dmitry
