Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbXE3MDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbXE3MDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXE3MDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:03:35 -0400
Received: from posti6.jyu.fi ([130.234.4.43]:54473 "EHLO posti6.jyu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbXE3MDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:03:34 -0400
Date: Wed, 30 May 2007 15:02:49 +0300 (EEST)
From: Tero Roponen <teanropo@jyu.fi>
X-X-Sender: teanropo@jalava.cc.jyu.fi
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: tty-related oops in latest kernel(s)?
In-Reply-To: <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705301458400.4634@jalava.cc.jyu.fi>
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi> 
 <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com> 
 <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com> 
 <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi> 
 <84144f020705291157k465ec6c4sb81081844bb57514@mail.gmail.com> 
 <Pine.LNX.4.64.0705300654493.5241@jalava.cc.jyu.fi>
 <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-360566268-1904625238-1180526569=:4634"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---360566268-1904625238-1180526569=:4634
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 30 May 2007, Pekka Enberg wrote:

> On 5/30/07, Tero Roponen <teanropo@jyu.fi> wrote:
> > Hmmm, I just found something interesting. In 2.6.21.3 the /sbin/init
> > gets corrupted when I watch the video!
> >
> > $ cp /sbin/init init.before
> > $ mplayer kiwi.flv
> > $ cp /sbin/init init.after
> >
> > The sha1sums are here:
> >
> > 52c8d643057619cbe137b8e69d4709ce3bdd832d  init.after
> > 8efc7864a5b535a9e336fa82e9d7f112f3d956c1  init.before
> >
> > It seems that something corrupts memory somewhere...
> 
> To debug this a bit further:
> 
> $ od -a -t x1 -v init.after > init.after.dump
> $ od -a -t x1 -v init.before > init.before.dump
> $ diff -u init.before.dump init.after.dump | less
> 
> -0011340  nul nul nul  e9  f0  fe  ff  ff  ff   %   < soh enq  bs   h  80
> -           00  00  00  e9  f0  fe  ff  ff  ff  25  3c  01  05  08  68  80
> +0010000    y ack nul nul   y ack nul nul   y ack nul nul   y ack nul nul
> +           79  06  00  00  79  06  00  00  79  06  00  00  79  06  00  00
> +0010020    y ack nul nul   y ack nul nul   y ack nul nul   y ack nul nul
> +           79  06  00  00  79  06  00  00  79  06  00  00  79  06  00  00
> +0011340    y ack nul nul   y ack nul nul  ff   %   < soh enq  bs   h  80
> +           79  06  00  00  79  06  00  00  ff  25  3c  01  05  08  68  80
> 
> The file at offset 0010000 - 0011348 is overwritten with the byte
> pattern 79 06 00 00.
> 
> Do you see anything in the logs or is this a silent corruption? Did
> you see this corruption with 2.6.19 or 2.6.22-rc3?
> 

I recompiled 2.6.22-rc3 and booted it with slub_debug. Now I can't oops
the kernel, but ./slab_info -v gives me a warning:

neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
neofb: no support for 32bpp
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1024x768) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1152x864) larger than the LCD panel (800x600)
Mode (1024x1024) larger than the LCD panel (800x600)
Mode (1024x1024) larger than the LCD panel (800x600)
Mode (1024x1024) larger than the LCD panel (800x600)
Mode (1024x1024) larger than the LCD panel (800x600)
Mode (1280x1024) larger than the LCD panel (800x600)
Mode (1280x1024) larger than the LCD panel (800x600)
Mode (1280x1024) larger than the LCD panel (800x600)
Mode (1280x1024) larger than the LCD panel (800x600)
*** SLUB kmalloc-1024: Redzone Active@0xc10be860 slab 0xc10217c0
    offset=2144 flags=0x80004082 inuse=7 freelist=0x00000000
  Bytes b4 0xc10be850:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
    Object 0xc10be860:  00 00 00 00 00 20 00 00 20 03 00 00 58 02 00 00 ............X...
    Object 0xc10be870:  20 03 00 00 58 02 00 00 00 00 00 00 00 00 00 00 ....X...........
    Object 0xc10be880:  10 00 00 00 00 00 00 00 0b 00 00 00 05 00 00 00 ................
    Object 0xc10be890:  00 00 00 00 05 00 00 00 06 00 00 00 00 00 00 00 ................
    Object 0xc10be8a0:  00 00 00 00 05 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xc10be8b0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    Object 0xc10be8c0:  ff ff ff ff ff ff ff ff 00 00 00 00 a8 61 00 00 ÿÿÿÿÿÿÿÿ....¨a..
    Object 0xc10be8d0:  58 00 00 00 28 00 00 00 17 00 00 00 01 00 00 00 X...(...........
   Redzone 0xc10bec60:  4d 6b 00 00                                     Mk..            
FreePointer 0xc10bec64 -> 0x00006b4d
Last alloc: 0x6b4d jiffies_ago=4294923792 cpu=27469 pid=27469
Last free : 0x6b4d jiffies_ago=4294923792 cpu=27469 pid=27469
    Filler 0xc10bec88:  4d 6b 00 00 4d 6b 00 00                         Mk..Mk..        
 [<c013f717>] check_object+0x64/0x23d
 [<c0141371>] validate_slab+0xff/0x12a
 [<c01413aa>] validate_slab_slab+0xe/0x51
 [<c0141488>] validate_store+0x9b/0xe8
 [<c01343d1>] __handle_mm_fault+0x370/0x68b
 [<c01413ed>] validate_store+0x0/0xe8
 [<c013eaa6>] slab_attr_store+0x1e/0x22
 [<c016e470>] sysfs_write_file+0xad/0xd6
 [<c016e3c3>] sysfs_write_file+0x0/0xd6
 [<c0143341>] vfs_write+0x8a/0x10c
 [<c01437d7>] sys_write+0x41/0x67
 [<c01022c2>] sysenter_past_esp+0x5f/0x85
 =======================
@@@ SLUB kmalloc-1024: Restoring redzone (0xcc) from 0xc10bec60-0xc10bec63

--
Tero Roponen
---360566268-1904625238-1180526569=:4634--
