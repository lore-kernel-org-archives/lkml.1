Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbXE1HWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbXE1HWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 03:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXE1HWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 03:22:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:24541 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbXE1HWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 03:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f/acKiX+XVaYfDpSuGlelwRyTnWODcIFcrq3F/TiLU2dsRZ5IdOe5ZDeUJPLuzmWT/IV3bC1scAr+TtZeh+DeNWcRfF35GazaVc20W0/queudKKj4xYVU7TXoNoAjZmdw4tyKYNp9kGUaxZpgVNspG7gss9EoE+3PjWF5GLMumY=
Message-ID: <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
Date: Mon, 28 May 2007 10:22:30 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Tero Roponen" <teanropo@jyu.fi>
Subject: Re: tty-related oops in latest kernel(s)?
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
X-Google-Sender-Auth: cc3e50ece38be2d9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tero,

(I am cc'ing Alan as he's been working on tty code recently.)

On 5/27/07, Tero Roponen <teanropo@jyu.fi> wrote:
> 2.6.22-rc3 (with Reiser4 patch) oopses when watching videos with
> mplayer using neofb console.

[snip]

> Ok, everything seems to work and I can watch the video.
> However, when the mplayer stops I get these warnings:
>
>   release_dev: driver.table[3] not tty for (tty4)
>   Warning: dev (tty4) tty->count(3) != #fd's(2) in release_dev
>   release_dev: driver.table[3] not tty for (tty4)

So sanity check for reference counting failed.

> When I try to repeat the previous step the kernel oopses:
>
>   neofb: no support for 32bpp
>   Mode (1024x768) larger than the LCD panel (800x600)
>   Mode (1152x864) larger than the LCD panel (800x600)
>   Mode (1024x1024) larger than the LCD panel (800x600)
>   Mode (1280x1024) larger than the LCD panel (800x600)
>   BUG: unable to handle kernel NULL pointer dereference at virtual address 00000731
>    printing eip:
>   c021e50e
>   *pde = 00000000
>   Oops: 0000 [#1]
>   Modules linked in: binfmt_misc floppy loop xirc2ps_cs pcmcia usb_storage parport_pc parport yenta_socket rsrc_nonstatic pcmcia_core evdev uhci_hcd usbcore
>   CPU:    0
>   EIP:    0060:[<c021e50e>]    Not tainted VLI
>   EFLAGS: 00010202   (2.6.22-rc3-atr #4)
>   EIP is at vt_ioctl+0xda8/0x1482
>   eax: 00000679   ebx: 00005600   ecx: c3d41200   edx: 00000000
>   esi: 0893159c   edi: c0386a2f   ebp: 00000003   esp: c26a5e28
>   ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
>   Process mplayer (pid: 1502, ti=c26a5000 task=c3a22500 task.ti=c26a5000)
>   Stack: fffffffe c26a5f30 c0149fd9 c29fe400 c3d68600 00000001 4642f7b0 c3d0bcc0
>          c3c32464 00000101 00000001 00000000 4644793c 4642f7b0 00000002 00000005
>          0000001b 00000005 c34ad240 c3d0bcc0 c1386000 00000002 00000000 c021d766
>   Call Trace:
>    [<c0149fd9>] link_path_walk+0xa5/0xaf
>    [<c021d766>] vt_ioctl+0x0/0x1482
>    [<c021a395>] tty_ioctl+0xa01/0xa87
>    [<c0143c5a>] get_empty_filp+0x4f/0xc9
>    [<c01439bf>] put_filp+0x14/0x31
>    [<c014ab93>] __path_lookup_intent_open+0x6c/0x75
>    [<c014ac10>] path_lookup_open+0x20/0x25
>    [<c014acd9>] open_namei+0x6e/0x51d
>    [<c0141b0c>] do_filp_open+0x25/0x39
>    [<c0219994>] tty_ioctl+0x0/0xa87
>    [<c014ba8a>] do_ioctl+0x3e/0x4d
>    [<c014bc84>] vfs_ioctl+0x1eb/0x202
>    [<c014bcce>] sys_ioctl+0x33/0x4d
>    [<c01022c2>] sysenter_past_esp+0x5f/0x85
>    =======================
>   Code: 0f b7 c8 7f 04 85 c9 75 cd 8d 4e 04 89 d8 e8 aa 11 fd ff e9 20 f8 ff ff 8d 04 95 00 00 00 00 03 81 b8 00 00 00 8b 00 85 c0 74 16 <83> b8 b8 00 00 00 00 74 0d 42 83 fa 3f 75 de b0 ff e9 88 f7 ff
>   EIP: [<c021e50e>] vt_ioctl+0xda8/0x1482 SS:ESP 0068:c26a5e28

Can we have your .config please? Also, could you work out the file and
line number of vt_ioctl+0xda8/0x1482 like this:

gdb vmlinux
(gdb) l *0xc021e50e

                                  Pekka
