Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYDCOpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYDCOpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbYDCOpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:45:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47609 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbYDCOpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:45:19 -0400
Subject: Re: Real time USB2Serial devices and behaivor
From: Peter Zijlstra <peterz@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Greg KH <greg@kroah.com>, mark gross <mgross@linux.intel.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <d82e647a0804030726r6432aafdvfa6395f0256dc97b@mail.gmail.com>
References: <20080326152559.GA17164@linux.intel.com>
	 <20080326162728.GC6020@kroah.com>
	 <d82e647a0804030726r6432aafdvfa6395f0256dc97b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 16:45:05 +0200
Message-Id: <1207233905.8514.834.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 22:26 +0800, Ming Lei wrote:
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
> 2),if I increase the read urb transfer size from one wMaxPacketSize
> to four wMaxPacketSize, the max read throughtput can be beyond 1440bps.
> But maybe there is some timeout risk, isn't there?
> 3),The throughput still can be increased by submitting more urbs
>  parallelly , and the latency can be decreased a bit by the way.

Non of which is relevant to realtime.

Realtime is about meeting deadlines, sod throughput (although if you can
get decent throughput while meeting the deadlines that's even better).

Realtime is about getting a signal on your serial port and reacting to
it before the $doom_scenario happens.

( I prefer the one where you break the laser guard and have to stop the
  saw blade before it cuts your fingers off - others prefer nuclear
  chain reactions )

