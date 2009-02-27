Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbZB0UiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbZB0UiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbZB0Ufm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:35:42 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46133 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760145AbZB0Ufl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:35:41 -0500
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <49A78C79.304@krogh.cc>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A6F39F.9040801@krogh.cc>
	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
	 <49A70B24.6090706@krogh.cc>
	 <1235685269.6811.11.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 12:35:36 -0800
Message-Id: <1235766936.7402.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 07:47 +0100, Jesper Krogh wrote:
> john stultz wrote:
> > Jesper: How long was the box up for when you noticed the ntpd noise?
> 
> I was booted Feb 25 21:58 .. the first noice from ntp starts here:
> Feb 25 22:09:53 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
> Feb 25 22:09:56 quad12 ntpd[4901]: synchronized to 10.194.133.13, stratum 4
> Feb 25 22:14:08 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
> Feb 25 22:16:20 quad12 ntpd[4901]: synchronized to 10.194.133.13, stratum 4
> Feb 25 22:32:25 quad12 ntpd[4901]: time reset -1.601641 s
> Feb 25 22:36:18 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
> Feb 25 22:36:45 quad12 ntpd[4901]: synchronized to 10.194.133.12, stratum 4
> Feb 25 22:51:41 quad12 ntpd[4901]: time reset -0.922993 s
> Feb 25 22:55:05 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13

Ok, so that's not very long. I'd expect by now, if the box is still up,
the messages have stopped. Is that true, or is it still resetting?


> > Also what's the output of the following under the different kernels:
> > ntpdc -c peers
> > ntpdc -c kerninfo
[snip]
> Working (clocksource=tsc) 2.6.26.8
> jk@quad03:~$ ntpdc -c kerninfo
> pll offset:           0.003208 s
> pll frequency:        -25.070 ppm
[snip]
> Non-working (clocksource=tsc) 2.6.29-rc6
> jk@quad12:~$ ntpdc -c kerninfo
> pll offset:           0 s
> pll frequency:        -34.754 ppm


Ok, so it seems ntp hasn't really had a chance to settle down, its only
made a 10ppm adjustment so far. NTPd will stop corrections at ~
+/-500ppm, so you're not at that bound yet, where things would be really
broken.

If the affected kernel isn't resetting in the logs anymore, I'd be
interested in what the new ppm value is.

thanks
-john


