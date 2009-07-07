Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbZGGPzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbZGGPzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZGGPzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:55:08 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:40781 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbZGGPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:55:07 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com>
	 <1246980836.9777.5.camel@twins>
	 <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com>
	 <1246981444.9777.11.camel@twins>
	 <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 17:55:01 +0200
Message-Id: <1246982101.9777.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 16:50 +0100, Joao Correia wrote:

> >> Yes. Anything 2.6.31 forward triggers this immediatly during init
> >> process, at random places.
> >
> > Not on my machines it doesn't.. so I suspect its something weird in
> > your .config or maybe due to some hardware you have that I don't that
> > triggers different drivers or somesuch.
> 
> I am not the only one reporting this, and it happens, for example,
> with a stock .config from a Fedora 11 install.
> 
> It may, of course, be a funny driver interaction yes, but other than
> stripping the box piece by piece, how would one go about debugging
> this otherwise?

One thing to do is stare (or share) at the output
of /proc/lockdep_chains and see if there's some particularly large
chains in there, or many of the same name or something.

/proc/lockdep_stats might also be interesting, mine reads like:

[root@opteron ~]# cat /proc/lockdep_stats
 lock-classes:                          641 [max: 8191]
 direct dependencies:                  3794 [max: 16384]
 indirect dependencies:                7557
 all direct dependencies:             73254
 dependency chains:                    3716 [max: 32768]
 dependency chain hlocks:             10167 [max: 163840]
 in-hardirq chains:                      21
 in-softirq chains:                     353
 in-process chains:                    3342
 stack-trace entries:                 91035 [max: 262144]
 combined max dependencies:        26035284
 hardirq-safe locks:                     28
 hardirq-unsafe locks:                  460
 softirq-safe locks:                    114
 softirq-unsafe locks:                  373
 irq-safe locks:                        123
 irq-unsafe locks:                      460
 hardirq-read-safe locks:                 0
 hardirq-read-unsafe locks:              45
 softirq-read-safe locks:                 8
 softirq-read-unsafe locks:              39
 irq-read-safe locks:                     8
 irq-read-unsafe locks:                  45
 uncategorized locks:                   106
 unused locks:                            1
 max locking depth:                      14
 max recursion depth:                    10
 debug_locks:                             1


