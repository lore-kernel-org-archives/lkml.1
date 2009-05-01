Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZEAJQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZEAJQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZEAJP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:15:58 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:59756 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbZEAJP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:15:57 -0400
Date: Fri, 1 May 2009 06:15:01 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@users.sf.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [2.6.30-rc2] usb reset during big file transfer and ext3 error
Message-ID: <20090501091501.GA29466@ime.usp.br>
References: <20090422220648.GB4066@ime.usp.br> <Pine.LNX.4.44L0.0904222236440.23171-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0904222236440.23171-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alan.

Sorry for the late reply, but I had some problems with an HD of mine
giving me trouble. :-( Of course, I have backups. :-)

On Apr 22 2009, Alan Stern wrote:
> On Wed, 22 Apr 2009, Rogério Brito wrote:
> > Is there any way of controlling the number of retries in the host
> > controller? Or, perhaps, of controlling the time between retries so
> > that the device can shape it up again?
> 
> It's not all that simple.  The host controller allows the OS to set the
> number of hardware retries to 1, 2, 3, or unlimited.  Linux uses 3;  
> those XactErr debugging messages in your log show that the driver was
> extending the number of retries in software.

Right. I didn't know that. Obviously, setting it to unlimited can give
undefined behavior of the computer.

> It's not possible to change the time interval between retries done by
> the hardware.  While it is possible in theory to change the interval
> between retries done by the driver, it would be rather difficult and
> so ehci-hcd doesn't attempt it.

Oh, what a pity. It seems that the device at hand sort of gets in shape
again after some time, since I have an automounter here and the device
nodes appear again under dev and it auto-mounts the device at the
appropriate mount point. Weird.

> The software retries were introduced to solve one particular problem:
> Many EHCI controllers will generate a transaction error if a data
> transfer is occurring on one port at the same time as a device is
> being unplugged on another port.

Right. I just got myself a (non powered) USB hub and I noticed one thing
(unrelated to this problem): if I plug a USB disk to this hub and, then,
plug a printer, very weird things happen, like the disc being unmounted
or things like that.

I can give you precise details of what happens here, if you're
interested.

OTOH, I think that I may be seeing some other problems with a pen drive
being connected to a port of this machine I'm typing this message on. I
will try to compile a newer kernel, now that -rc4 is released and I
would appreciate if you could help me with the issues that I'm seeing.

> This is clearly a hardware bug, and the software retries were intended
> to work around it.  In practice only a couple of software retries are
> needed; if the transfer hasn't succeeded by that point then it's never
> going to succeed.  I set the upper limit to 32 retries just to be
> conservative.

OK. Thanks for the nice and clear explanation of the problem. I only
wonder why I not seeing these errors on other machines while I *do* see
them on other machines (this one is an intel ICH5).

> If transaction errors aren't caused by noise in the cable then they
> are almost always caused by bugs or failures in the device.

I will try again with a shorter and newer cable. Let's see how that
works. BTW, is there any way to check the quality of a cable? I have a
multimeter here and I would be willing to do some extensive tests.
Testing the USB enclosure is also pretty feasible.

> Once a device's firmware has crashed, it doesn't magically fix itself.

Oh, what a pity that it doesn't recovers itself with a watchdog-like
mechanism.


Thanks for all your help, Rogério.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
