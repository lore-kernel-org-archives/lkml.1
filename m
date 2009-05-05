Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZEEFmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZEEFmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 01:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZEEFmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 01:42:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:53690 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751378AbZEEFmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 01:42:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Ovmc7BGZOuopxj0om1kamnt3oTSnDxfV1vfhlJb
	xPSpobaYhLaQc3
Subject: Re: CFS not suitable for desktop computers
From: Mike Galbraith <efault@gmx.de>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Nico =?ISO-8859-1?Q?Sch=FCmann?= <spam@nico22.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49FF57AC.7070104@nortel.com>
References: <49FDEFD1.8020608@nico22.de>
	 <1241424835.26855.102.camel@marge.simson.net> <49FF06D0.80109@nico22.de>
	 <49FF57AC.7070104@nortel.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 05 May 2009 07:42:08 +0200
Message-Id: <1241502128.5505.62.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 15:01 -0600, Chris Friesen wrote:
> Nico Schümann wrote:
> > Thank you Ray Lee and Mike Galbraith for your responses, I ran the 
> > script and attached its gathered information.
> > 
> > Mike Galbraith wrote:
> >> How hard is hard?  Can you describe the loads you're having trouble
> >> with, and the hardware you're running them on?
> >>
> >>   
> > I could reproduce "hard" load by just compiling the linux kernel, make 
> > -j3 while reading mails with Thunderbird, which is not that hard 
> > foreground load. Thunderbird starts reacting really slowly while compiling.
> 
> I wonder if this could be related to I/O rather than the task scheduler 
> proper.

That's something I was wondering as well, particularly when I noticed
he's using data=journal and anticipatory io-scheduler.

Doing some testing with different journal modes and io-schedulers
recently, I found loads where anticipatory didn't do very well compared
to cfq, and journal mode can make a tremendous difference ala..

time ./postmark < config

          ordered     writeback      guarded      journal
real    11m18.752s    3m5.160s     3m1.367s    15m18.610s
user    0m5.672s      0m6.220s     0m5.976s    0m6.856s
sys     0m26.094s     0m20.965s    0m21.673s   0m20.969s

real    9m33.922s     2m53.984s    3m6.284s    15m12.969s
user    0m5.700s      0m5.976s     0m6.356s    0m6.980s
sys     0m26.682s     0m21.413s    0m20.717s   0m19.641s

real    10m8.766s     3m0.382s     2m58.714s   15m33.400s
user    0m5.608s      0m6.080s     0m6.232s    0m6.776s
sys     0m27.130s     0m21.041s    0m21.709s   0m19.489s

	-Mike

