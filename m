Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbXLZDmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbXLZDmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 22:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXLZDmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 22:42:04 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1738 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751439AbXLZDmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 22:42:01 -0500
Date: Tue, 25 Dec 2007 22:42:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Victor Hahn <victor@open-bash.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: Can't disconnect a USB sound device and connect another
In-Reply-To: <20071225140450.b6d742bb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0712252236120.25960-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Dec 2007, Andrew Morton wrote:

> On Sun, 23 Dec 2007 23:36:11 +0100 Victor Hahn <victor@open-bash.org> wrote:
> 
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > ... because it causes lsusb to freeze and gives me this in /var/log/messages:
> 
> Has this always happened, or is it something we introduced in a recent
> kernel?
> 
> > Dec 23 23:27:04 cabrio kernel: usb 2-2: USB disconnect, address 5
> > Dec 23 23:27:04 cabrio kernel: PGD 110f2067 PUD 110f3067 PMD 0
> > Dec 23 23:27:04 cabrio kernel: CPU 0
> > Dec 23 23:27:04 cabrio kernel: Modules linked in: videodev v4l2_common 
> > v4l1_compat snd_rtctimer binfmt_misc rfcomm l2cap bluetooth capability 
...
> > Dec 23 23:27:04 cabrio kernel: Pid: 2052, comm: khubd Not tainted 2.6.23.11 #1
> > Dec 23 23:27:04 cabrio kernel: RIP: 0010:[_end+130488219/2130651808]  
> > [_end+130488219/2130651808] :snd:snd_ctl_dev_disconnect+0x6b/0xb0
> > Dec 23 23:27:04 cabrio kernel: RSP: 0018:ffff810037bfdc40  EFLAGS: 00010282
> > Dec 23 23:27:04 cabrio kernel: RAX: 0000000000000000 RBX: 0000000000100100 
> > RCX: 0000000000000018
> > Dec 23 23:27:04 cabrio kernel: RDX: 0000000000020004 RSI: 000000000000001d 
> > RDI: ffff810013e98c08
> > Dec 23 23:27:04 cabrio kernel: RBP: ffff8100394631a8 R08: ffff810037bfc000 
> > R09: 0000000000000000
...
> > Dec 23 23:27:04 cabrio kernel: Process khubd (pid: 2052, threadinfo 
> > ffff810037bfc000, task ffff81003d67d0c0)
> > Dec 23 23:27:04 cabrio kernel: Stack:  0000000000000000 ffff810038850d00 
> > ffff810039463000 ffff810039463150
> > Dec 23 23:27:04 cabrio kernel:  0000000000000000 ffffffff88281e69 
> > ffff810038850d00 ffffffff882821ac
> > Dec 23 23:27:04 cabrio kernel:  0000000000000000 0000000000000000 
> > ffff810039463000 ffff8100394631e0
> > Dec 23 23:27:04 cabrio kernel: Call Trace:
> > Dec 23 23:27:04 cabrio kernel:  
> > [_end+130500873/2130651808] :snd:snd_device_disconnect+0x59/0x90
> > Dec 23 23:27:04 cabrio kernel:  
...
> > Is there a way to exchange USB audio devices without rebooting?
> 
> First we have to work out if it's a USB bug or an ALSA bug.  I'd guess
> ALSA, but not with a lot of confidence.
> 
> Anyone?

There have been similar reports of this bug.  To me it looks like an
ALSA problem.  The routine in question, snd_ctl_dev_disconnect(), is an
ALSA callback and doesn't contain any USB code.

A good way to start would be to obtain a disassembly listing of that 
routine, so we can find out what C statement caused the bug.

Alan Stern

