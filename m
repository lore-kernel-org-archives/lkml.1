Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbYJSPfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbYJSPfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 11:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYJSPe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 11:34:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2522 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751359AbYJSPe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 11:34:57 -0400
Date: Sun, 19 Oct 2008 11:34:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: Kernel 2.6.26.5 -> 2.6.27.2 [USB REGRESSION] (USB -> D_STATE)
In-Reply-To: <alpine.DEB.1.10.0810190728030.26990@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.0810191130050.17760-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008, Justin Piszcz wrote:

> On Sun, 19 Oct 2008, Justin Piszcz wrote:
> 
> > With kernel 2.6.27.2, any processes attempting to use USB hang and go into 
> > D-state, I have never had a problem like this before until 2.6.27.2 (I have 
> > not tried 2.6.27.1 or 2.6.27)
> >
> > # lsusb -v
> > <hangs>
> >
> > open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 
> > 3
> > fstat64(3, {st_mode=S_IFDIR|0755, st_size=140, ...}) = 0
> > getdents(3, /* 7 entries */, 4096)      = 112
> > getdents(3, /* 0 entries */, 4096)      = 0
> > close(3)                                = 0
> > open("/dev/bus/usb/001", 
> > O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
> > fstat64(3, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
> > getdents(3, /* 4 entries */, 4096)      = 64
> > open("/dev/bus/usb/001/004", O_RDWR)    = 4
> > ioctl(4, USBDEVFS_CONNECTINFO
> >
> > nut (for UPS) does not start.
> >
> > nut       4078  0.0  0.0   1964   856 pts/8    D    07:09   0:00 
> > /lib/nut/usbhid-ups -a belkin
> > root      4170  0.0  0.0   2204  1072 pts/8    D+   07:11   0:00 lsusb -v
> >
> > Processes go directly to D-state with 2.6.27.2 for USB.
> >
> > Booting back to 2.6.26.5 now to see if everything works again.
> >
> > Back to 2.6.25.5, everything works fine:
> >
> > # lsusb Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 001 Device 004: ID 2040:7501 Hauppauge Bus 001 Device 001: ID 1d6b:0002 
> > Linux Foundation 2.0 root hub
> > Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 003 Device 002: ID 050d:1100 Belkin Components Bus 003 Device 001: ID 
> > 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 002 Device 002: ID 045e:0039 Microsoft Corp. IntelliMouse Optical
> > Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> >
> > Relevant configuration files and dmesg output:
> >
> 
> http://home.comcast.net/~jpiszcz/20081019/2.6.25.5-usb-working.txt
> http://home.comcast.net/~jpiszcz/20081019/2.6.27.2-usb-broken.txt
> http://home.comcast.net/~jpiszcz/20081019/linux-2.6.25.5-config.txt
> http://home.comcast.net/~jpiszcz/20081019/linux-2.6.27.2-config.txt

You should turn on the usbfs_snoop module parameter for usbcore and see
what shows up in the system log.

Alan Stern

