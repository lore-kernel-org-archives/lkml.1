Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbZBZWbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbZBZWbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZBZWba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:31:30 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40650 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbZBZWb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:31:29 -0500
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A6F39F.9040801@krogh.cc>
	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
	 <49A70B24.6090706@krogh.cc>
	 <1235685269.6811.11.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 14:31:23 -0800
Message-Id: <1235687483.6811.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 23:06 +0100, Thomas Gleixner wrote:
> On Thu, 26 Feb 2009, john stultz wrote:
> > On Thu, 2009-02-26 at 22:35 +0100, Jesper Krogh wrote:
> > > > Also mind sending the full dmesg for both kernels?
> > > 
> > > http://krogh.cc/~jesper/dmesg-2.6.29-rc6.txt
> > > http://krogh.cc/~jesper/dmesg-2.6.26.8.txt
> > 
> > So one interesting difference:
> > 2.6.26.8:	TSC calibrated against PM_TIMER
> > 2.6.29-rc6:	Fast TSC calibration using PIT
> > 
> > Thomas, any thoughts as to why we might be calibrating off the PIT
> > instead of the PM_TIMER w/ 2.6.29?
> 
> Yup, because we introduced the Fast PIT calibration in 2.6.28.

Ah. Ok.

> Is the delta anything NTP might get upset about:
> 
> 2.6.26: time.c: Detected 2311.847 MHz processor.
> 2.6.29: Detected 2310.029 MHz processor.

I wouldn't think so.

Although, I'm recalling on some systems here right after we deploy them
we'll see something similar to the originally reported ntpd "time reset"
noise for a period of time while ntpd tries to find the right freq. For
some reason, I've noticed, having multiple servers in your ntp.conf
seems to increase NTP's difficulty at picking a time and converging. 

So this may be just the slight calibration change is confusing ntp or it
may be the NTP_INTERVAL_LENGTH change from awhile back which would cause
the drift value to change could be doing the same thing (although I
thought that landed in the 2.6.24 timeframe, but I may be forgetting).

I'll kick up some of my own testing between these two releases to see if
I can't find something similar.

Jesper: How long was the box up for when you noticed the ntpd noise?

Also what's the output of the following under the different kernels:
ntpdc -c peers
ntpdc -c kerninfo

thanks
-john

