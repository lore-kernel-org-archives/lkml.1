Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839Ab0AVJLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0AVJLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681Ab0AVJLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:11:07 -0500
Received: from mail.gmx.net ([213.165.64.20]:49271 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752671Ab0AVJLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:11:02 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/fvgVvHvbfpme0AeW65MKY1mPK4xbOZnsgEUqDrV
	2PX/dk/zBUaemO
Subject: Re: scheduler vs hardware? (was Re: another i7  (linux) bug?)
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Luca Zini <luca.zini@gmail.com>, aagaande@gmail.com, rdelcueto@hotmail.com,
       mingo@elte.hu, linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>
In-Reply-To: <1264150272.4283.1361.camel@laptop>
References: <201001211258.23499.luca.zini@gmail.com>
	 <20100121215438.GK17684@ldl.fc.hp.com>
	 <1264144758.8074.22.camel@marge.simson.net>
	 <1264150272.4283.1361.camel@laptop>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 10:10:57 +0100
Message-Id: <1264151457.12530.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 09:51 +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-22 at 08:19 +0100, Mike Galbraith wrote:
> > > if I run a cpu intensive process with the lowest priority (19
> > > from man nice) I obtain much better performance that with the
> > > highest priority available (-20 from man nice).
> > >
> > > For example the same file is processed by lame in 8.7 seconds
> > > at the lowest priority, and in 12 seconds at the highest
> > > priority.  Before posting a bug I wold like to understand if
> > > this is a problem related to the i7 mobile (my processor is a
> > > i7 Q720).
> > > 
> > > As far as I tested on the same laptop series (dell studio 15),
> > > with the same kernel this problem does not exists.
> > 
> > So you only see this on the i7.  That's odd.  Can you try 33-rc5?
> > 
> > Posting a reliable reproducer would be nice.  It'd also be nice to see
> > what all is running when you see this, and where.
> 
> Using a sample from: http://lame.sourceforge.net/quality.php
> 
> My laptop does:
> 
> 
> # time nice -n 19 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

> real    0m3.273s
> user    0m3.217s
> sys     0m0.022s
> 
> 
> # time nice -n 0 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null 

> real    0m1.121s
> user    0m1.102s
> sys     0m0.013s
> 
> 
> # time nice -n -20 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

> real    0m1.112s
> user    0m1.093s
> sys     0m0.018s
> 
> 
> 
> On a Nehalem class server machine it does:
> 
> 
> # time nice -n 19 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

> real    0m0.932s
> user    0m0.917s
> sys     0m0.005s
> 
> 
> # time nice -n 0 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

> real    0m0.927s
> user    0m0.922s
> sys     0m0.003s
> 
> 
> # time nice -n -20 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

> real    0m0.919s
> user    0m0.914s
> sys     0m0.005s

Weird.  Here there is zip squat difference, as expected with 1 thread.

time nice -n 19 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

real    0m0.912s
user    0m0.908s
sys     0m0.000s

time nice -n 0 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

real    0m0.912s
user    0m0.904s
sys     0m0.004s

time nice -n -20 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

real    0m0.912s
user    0m0.904s
sys     0m0.004s

(bah, who needs a nehalem;)

	-Mike

