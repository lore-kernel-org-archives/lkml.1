Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbYDCPxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbYDCPxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbYDCPxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:53:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54823 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbYDCPxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:53:03 -0400
Date: Thu, 3 Apr 2008 08:52:17 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: mark gross <mgross@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Real time USB2Serial devices and behaivor
Message-ID: <20080403155217.GB10425@kroah.com>
References: <20080326152559.GA17164@linux.intel.com> <20080326162728.GC6020@kroah.com> <d82e647a0804030726r6432aafdvfa6395f0256dc97b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0804030726r6432aafdvfa6395f0256dc97b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 10:26:57PM +0800, Ming Lei wrote:
> 2008/3/27, Greg KH <greg@kroah.com>:
> > On Wed, Mar 26, 2008 at 08:25:59AM -0700, mark gross wrote:
> >  > At home I'm playing with a real time amateur robotics application with a
> >  > micro controller talking over its serial port to a Linux box running an RT
> >  > kernel and some RT user mode software to suck in the serial port data
> >  > and do some processing in real time.  One example of what I want to do
> >  > with this type of configuration is to create a type of IMU thing and run
> >  > the data through a kalman filter to see how good I can do with my
> >  > hardware.
> >  >
> >  > I'll be sending data regularly at data rates between 50 and 500 HZ from
> >  > the MCU (depending on mode)
> >  >
> >  > Anyway, I have the RT code and the system prototyped using the hardware
> >  > serial port on my desktop and I'm getting rock solid RT delivery times
> >  > of the data +/- 30usec.  While stressing the system in CPU and disk. (I
> >  > still need to do the test while flood pinging the box)  However; when I
> >  > use my USB dongle instead of the hardware serial port the system falls
> >  > over WRT real time behavior.
> >  >
> >  > I'm just starting to look into the behavior now but has anyone looked at
> >  > the RT'ness of USB2Serial + USB stack yet?  I would like to see what
> >  > other folks have done.  My googleing last night didn't get any useful
> >  > hits.
> >
> >
> > I have, and others have in the past, and it's something that you can not
> >  really do.  USB is not "deterministic", and these cheap usb to serial
> >  devices introduce a very big lag that also is not deterministic.
> >
> 
> I had done some usb serial test about 2 weeks ago and found :
> 1),the max read thoughtput is 480bps,using the generic usb
>  serial driver and a wireless cdma usb card.

The generic usb serial driver is KNOWN TO BE A VERY SLOW DRIVER!

I'm getting very tired of repeating myself about this one, don't do any
speed tests, or run any real hardware modems with this driver at all,
it's just not worth it.

The code was not designed to be fast, only get the job done.

> 2),if I increase the read urb transfer size from one wMaxPacketSize
> to four wMaxPacketSize, the max read throughtput can be beyond 1440bps.
> But maybe there is some timeout risk, isn't there?

That's one way to increase speed, but not the only way, it can be done a
whole lot better if you are worried about throughput.  See the sierra
driver for an implementation that does this correctly for maximum
througput.

> 3),The throughput still can be increased by submitting more urbs
>  parallelly , and the latency can be decreased a bit by the way.

But again, that has nothing to do with determinism, or latency, or real
time issues.

thanks,

greg k-h
