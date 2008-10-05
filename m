Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYJEVB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYJEVB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYJEVBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:01:49 -0400
Received: from 1wt.eu ([62.212.114.60]:4624 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbYJEVBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:01:48 -0400
Date: Sun, 5 Oct 2008 23:01:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: Klaus Ethgen <Klaus@Ethgen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [KERNEL] Re: Kernel freeze on 2.4.36.7
Message-ID: <20081005210144.GA7980@1wt.eu>
References: <20081005154113.GA8387@ikki.ethgen.de> <20081005171818.GJ24654@1wt.eu> <20081005204247.GA3781@ikki.ethgen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005204247.GA3781@ikki.ethgen.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 09:42:54PM +0100, Klaus Ethgen wrote:
> Am So den  5. Okt 2008 um 18:18 schrieb Willy Tarreau:
> > > I got a new barcode scanner and plugged it into USB. The scanner works
> > > well until I remove it. In that second I get a trace and the kernel
> > > freeze.
> > 
> > Does it happen everytime you unplug it or only once in a while ?
> 
> Everytime.

OK, that's better (not for you of course).

> Well, thats not that true. It WAS everytime until I close all
> applications and did sync several times before I unplug the device. When
> I wait a view seconds after the sync the freeze is reproducible.

Sounds like the application directly attaches to the device itself and
we have some internal pointer becoming NULL when the device disappears.

> > Also, have you ever been running and older 2.4 kernel not causing this
> > problem ?
> 
> I did buy the scanner only days ago. I did not use older kernels since
> then. (I have to compile some if it is needed.)

OK, so we'll assume it's not a regression and has always been like that,
which is the most likely.

> > > The message when I unplug it:
> > >  Unable to handle kernel NULL pointer dereference at virtual address 00000048
> > >  ...
> > 
> > Does the same problem happen when you plug/unplug a USB keyboard on the
> > same machine ?
> 
> Yes. I just tested it and my machine was frozen.

Good too. It should be easier to reproduce.

> > > Please pardon that I do not type the complete kernel dump as I know no
> > > way to log it to a text file in this case where the system freeze. But
> > > on request I can send the picture I made with my camera.
> > 
> > Yes, it would help a lot. That along with your kernel config and an
> > lsmod and dmesg outputs before the problem. Ideally, you should pass
> > the messages output through ksymoops with all modules loaded as before
> > the problem happens.
> 
> It should be on this mail.

OK. I see an nvidia module. Would this machine happen to run under X ?
If so, did you configure X so that it directly references the HID devices ?

Also, could you tell us a bit more about the application, and how you have
to proceed to avoid the problem ? Eg: quit the application then X, etc...

> > If you want to more easily capture your messages, you can connect
> > another machine to your serial port and boot with "console=ttyS0".
> 
> Thats not possible as I did not compile the serial console into the
> kernel.

OK. Before I ask you to do so, could you send me privately your System.map,
a copy of /proc/ksyms and your vmlinux (not vmlinuz) ? Oh, and if you're
running X, please also send your X config file, just in case.

Maybe we can find the faulty function there.

Regards,
Willy

