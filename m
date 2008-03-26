Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYCZQWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYCZQWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYCZQWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:22:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55886 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYCZQWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:22:08 -0400
Date: Wed, 26 Mar 2008 09:27:28 -0700
From: Greg KH <greg@kroah.com>
To: mark gross <mgross@linux.intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Real time USB2Serial devices and behaivor
Message-ID: <20080326162728.GC6020@kroah.com>
References: <20080326152559.GA17164@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326152559.GA17164@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 08:25:59AM -0700, mark gross wrote:
> At home I'm playing with a real time amateur robotics application with a
> micro controller talking over its serial port to a Linux box running an RT
> kernel and some RT user mode software to suck in the serial port data
> and do some processing in real time.  One example of what I want to do
> with this type of configuration is to create a type of IMU thing and run
> the data through a kalman filter to see how good I can do with my
> hardware.
> 
> I'll be sending data regularly at data rates between 50 and 500 HZ from
> the MCU (depending on mode)
> 
> Anyway, I have the RT code and the system prototyped using the hardware
> serial port on my desktop and I'm getting rock solid RT delivery times
> of the data +/- 30usec.  While stressing the system in CPU and disk. (I
> still need to do the test while flood pinging the box)  However; when I
> use my USB dongle instead of the hardware serial port the system falls
> over WRT real time behavior.
> 
> I'm just starting to look into the behavior now but has anyone looked at
> the RT'ness of USB2Serial + USB stack yet?  I would like to see what
> other folks have done.  My googleing last night didn't get any useful
> hits.

I have, and others have in the past, and it's something that you can not
really do.  USB is not "deterministic", and these cheap usb to serial
devices introduce a very big lag that also is not deterministic.

I wouldn't recommend using USB for anything that you need to be able to
accuratly control the latency of, it's just not going to work as that is
not what it was designed for at all.

> BTW Why does the PL2303 have a 1KB buffer for incoming data?

The device or the driver?

> I'm a bit green at RT work at this level.  What are the best ways for
> drilling down to figure out what the problems are so I can make a patch?

Give up and use a "real" serial port, you'll have better luck :)

thanks,

greg k-h
