Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbYDCO1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbYDCO1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbYDCO1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:27:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:51756 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470AbYDCO06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dfkEJd50L1mIvzAw2OiqSNNKcTW1Uy5WfJpwSXncvWlQj+PLxLy/9CDCOHn4Su5XTzwO8MR5ZuNpqnDIoWrz/SBuZjJofFRdfDIt8MH62cABMApAJcr0CjWtezauJMKKGSo6FXC0gPlzf4cndwNwUXv80gp4ZZ90zCvohT+iR78=
Message-ID: <d82e647a0804030726r6432aafdvfa6395f0256dc97b@mail.gmail.com>
Date: Thu, 3 Apr 2008 22:26:57 +0800
From: "Ming Lei" <tom.leiming@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Real time USB2Serial devices and behaivor
Cc: "mark gross" <mgross@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20080326162728.GC6020@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326152559.GA17164@linux.intel.com>
	 <20080326162728.GC6020@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/27, Greg KH <greg@kroah.com>:
> On Wed, Mar 26, 2008 at 08:25:59AM -0700, mark gross wrote:
>  > At home I'm playing with a real time amateur robotics application with a
>  > micro controller talking over its serial port to a Linux box running an RT
>  > kernel and some RT user mode software to suck in the serial port data
>  > and do some processing in real time.  One example of what I want to do
>  > with this type of configuration is to create a type of IMU thing and run
>  > the data through a kalman filter to see how good I can do with my
>  > hardware.
>  >
>  > I'll be sending data regularly at data rates between 50 and 500 HZ from
>  > the MCU (depending on mode)
>  >
>  > Anyway, I have the RT code and the system prototyped using the hardware
>  > serial port on my desktop and I'm getting rock solid RT delivery times
>  > of the data +/- 30usec.  While stressing the system in CPU and disk. (I
>  > still need to do the test while flood pinging the box)  However; when I
>  > use my USB dongle instead of the hardware serial port the system falls
>  > over WRT real time behavior.
>  >
>  > I'm just starting to look into the behavior now but has anyone looked at
>  > the RT'ness of USB2Serial + USB stack yet?  I would like to see what
>  > other folks have done.  My googleing last night didn't get any useful
>  > hits.
>
>
> I have, and others have in the past, and it's something that you can not
>  really do.  USB is not "deterministic", and these cheap usb to serial
>  devices introduce a very big lag that also is not deterministic.
>

I had done some usb serial test about 2 weeks ago and found :
1),the max read thoughtput is 480bps,using the generic usb
 serial driver and a wireless cdma usb card.
2),if I increase the read urb transfer size from one wMaxPacketSize
to four wMaxPacketSize, the max read throughtput can be beyond 1440bps.
But maybe there is some timeout risk, isn't there?
3),The throughput still can be increased by submitting more urbs
 parallelly , and the latency can be decreased a bit by the way.

>  I wouldn't recommend using USB for anything that you need to be able to
>  accuratly control the latency of, it's just not going to work as that is
>  not what it was designed for at all.
>
>
>  > BTW Why does the PL2303 have a 1KB buffer for incoming data?
>
>
> The device or the driver?
>
>
>  > I'm a bit green at RT work at this level.  What are the best ways for
>  > drilling down to figure out what the problems are so I can make a patch?
>
>
> Give up and use a "real" serial port, you'll have better luck :)
>
>  thanks,
>
>  greg k-h
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Lei Ming
