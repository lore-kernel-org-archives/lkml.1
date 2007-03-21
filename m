Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXCUPYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXCUPYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbXCUPYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:24:40 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33856 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbXCUPYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:24:39 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 21 Mar 2007 08:23:56 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: AIO, FIO and Threads ...
In-Reply-To: <20070321074014.GD14389@kernel.dk>
Message-ID: <Pine.LNX.4.64.0703210815190.24472@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703202146570.28960@alien.or.mcafeemobile.com>
 <20070321074014.GD14389@kernel.dk>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Jens Axboe wrote:

> On Tue, Mar 20 2007, Davide Libenzi wrote:
> > 
> > I was looking at Jens FIO stuff, and I decided to cook a quick patch for 
> > FIO to support GUASI (Generic Userspace Asyncronous Syscall Interface):
> > 
> > http://www.xmailserver.org/guasi-lib.html
> > 
> > I then ran a few tests on my Dual Opteron 252 with SATA drives (sata_nv) 
> > and 8GB of RAM.
> > Mind that I'm not FIO expert, like at all, but I got some interesting 
> > results when comparing GUASI with libaio at 8/1000/10000 depths.
> > If I read those result correctly (Jens may help), GUASI output is more 
> > then double the libaio one.
> > Lots of context switches, yes. But the throughput looks like 2+ times.
> > Can someone try to repeat the measures and/or spot the error?
> > Or tell me which other tests to run?
> > This is kinda a suprise for me ...
> 
> I don't know guasi at all, but libaio requires O_DIRECT to be async. I'm
> sure you know this, but you may not know that fio default to buffered IO
> so you have to tell it to use O_DIRECT :-)
> 
> So try adding a --direct=1 (or --buffered=0, same thing) as an extra
> option when comparing depths > 1.

I knew about AIO and O_DIRECT, but I thought FIO was using it by default :)
I used it for the first time yesterday night, and there are a pretty wide 
set of options. Will re-run today with --direct.
I was pretty surprised though. Since libaio was matching with syslets, I 
was thinking that a userspace version using a queue-always design (hard to 
do the cachehit optimization if you're not inside the scheduler ;), was 
going to be considerably slower.


> I'll add your guasi engine, but disable it. Unfortunately fio still
> doesn't have a nifty configure setup, so these things are still
> manual...

Well, you do have your own HAVE_*, you just need to make autoconf/automake 
do the checks for you. Of course, then you'll be pissed every time an 
autoconf/automake update break your setup, but lately it seems to be going 
better. Really :)


- Davide


