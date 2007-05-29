Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbXE2QFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbXE2QFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXE2QE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:04:57 -0400
Received: from posti6.jyu.fi ([130.234.4.43]:53900 "EHLO posti6.jyu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbXE2QE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:04:56 -0400
Date: Tue, 29 May 2007 19:04:12 +0300 (EEST)
From: Tero Roponen <teanropo@jyu.fi>
X-X-Sender: teanropo@jalava.cc.jyu.fi
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: tty-related oops in latest kernel(s)?
In-Reply-To: <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi>
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi> 
 <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
 <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007, Pekka Enberg wrote:

> I am getting this with your config:
> 
> (gdb) p vt_ioctl
> $1 = {int (struct tty_struct *, struct file *, unsigned int, long
> unsigned int)} 0xc01e404a <vt_ioctl>
> (gdb) l *(0xc01e404a + 0xda8)
> 0xc01e4df2 is in vt_ioctl (drivers/char/vt_ioctl.c:720).
> 715             /*
> 716              * Returns the first available (non-opened) console.
> 717              */
> 718             case VT_OPENQRY:
> 719                     for (i = 0; i < MAX_NR_CONSOLES; ++i)
> 720                             if (! VT_IS_IN_USE(i))
> 721                                     break;
> 722                     ucval = i < MAX_NR_CONSOLES ? (i+1) : -1;
> 723                     goto setint;
> 724
> 
> Which seems to match the code dump in the OOPS as well. I am not sure
> what %edx (which is zero and causes problems) should contain but I am
> guessing tty_driver->ttys is corrupted which seems consistent with the
> reference count sanity check failure. Unfortunately I am not familiar
> enough with tty internals to immediately see why this is happening.
> 

FYI, I just tested 2.6.21.3. I couldn't reproduce the problem with
that kernel.

--
Tero Roponen
