Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbYCZQxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbYCZQxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760711AbYCZQwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:52:54 -0400
Received: from mga06.intel.com ([134.134.136.21]:5390 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760696AbYCZQww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:52:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,559,1199692800"; 
   d="scan'208";a="361000063"
Date: Wed, 26 Mar 2008 09:49:46 -0700
From: mark gross <mgross@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Real time USB2Serial devices and behaivor
Message-ID: <20080326164946.GA17928@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080326152559.GA17164@linux.intel.com> <20080326162728.GC6020@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326162728.GC6020@kroah.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 26 Mar 2008 16:44:00.0263 (UTC) FILETIME=[97922970:01C88F60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 09:27:28AM -0700, Greg KH wrote:
> On Wed, Mar 26, 2008 at 08:25:59AM -0700, mark gross wrote:
> > At home I'm playing with a real time amateur robotics application with a
> > micro controller talking over its serial port to a Linux box running an RT
> > kernel and some RT user mode software to suck in the serial port data
> > and do some processing in real time.  One example of what I want to do
> > with this type of configuration is to create a type of IMU thing and run
> > the data through a kalman filter to see how good I can do with my
> > hardware.
> > 
> > I'll be sending data regularly at data rates between 50 and 500 HZ from
> > the MCU (depending on mode)
> > 
> > Anyway, I have the RT code and the system prototyped using the hardware
> > serial port on my desktop and I'm getting rock solid RT delivery times
> > of the data +/- 30usec.  While stressing the system in CPU and disk. (I
> > still need to do the test while flood pinging the box)  However; when I
> > use my USB dongle instead of the hardware serial port the system falls
> > over WRT real time behavior.
> > 
> > I'm just starting to look into the behavior now but has anyone looked at
> > the RT'ness of USB2Serial + USB stack yet?  I would like to see what
> > other folks have done.  My googleing last night didn't get any useful
> > hits.
> 
> I have, and others have in the past, and it's something that you can not
> really do.  USB is not "deterministic", and these cheap usb to serial
> devices introduce a very big lag that also is not deterministic.
> 

I'm seeing some of that today :(

> I wouldn't recommend using USB for anything that you need to be able to
> accuratly control the latency of, it's just not going to work as that is
> not what it was designed for at all.

Oh, thats a drag.  I know bulk has retries, and that on a clean bus they
don't happen (well as far as my hobby use they shouldn't, real
applications should use isochronous streams to avoid them.)

What is the root cause for the non deterministic behavior?  HW or USB
stack?

Is there any reason to think that if I created my own isochronous
USB2Serial adapter and iso-usb-driver that I couldn't get determinism?

There are a few hackable devices I have (USB-Bitwacker and the LPC2148)
I could implement isoc-endpoint firmware and driver for to make a
ISO-USB2Serial device.  But I don't want to go down that path if its got
no chance of success.


> 
> > BTW Why does the PL2303 have a 1KB buffer for incoming data?
> 
> The device or the driver?

driver.

> 
> > I'm a bit green at RT work at this level.  What are the best ways for
> > drilling down to figure out what the problems are so I can make a patch?
> 
> Give up and use a "real" serial port, you'll have better luck :)

but its getting very hard to find real serial ports any more :(


Thanks,

--mgross

