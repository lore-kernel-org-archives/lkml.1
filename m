Return-Path: <linux-kernel-owner+w=401wt.eu-S1423083AbXDXTks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423083AbXDXTks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423087AbXDXTks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:40:48 -0400
Received: from wasp.net.au ([203.190.192.17]:45828 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423083AbXDXTkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:40:47 -0400
Message-ID: <462E5D38.5000801@wasp.net.au>
Date: Tue, 24 Apr 2007 23:40:40 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Neil Brown <neilb@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
References: <4621FAF0.7000705@wasp.net.au> <46220339.9080205@wasp.net.au> <4623FB29.1000603@redhat.com> <17956.22235.574867.179016@notabene.brown> <20070418123757.GC3796@kernel.dk> <46261ACE.1050407@wasp.net.au> <20070418132157.GC3720@kernel.dk> <462B10C3.1030906@wasp.net.au> <20070423073543.GE5311@kernel.dk>
In-Reply-To: <20070423073543.GE5311@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:

> Ok, can you try and reproduce with this one applied? It'll keep the
> system running (unless there are other corruptions going on), so it
> should help you a bit as well. It will dump some cfq state info when the
> condition triggers that can perhaps help diagnose this. So if you can
> apply this patch and reproduce + send the output, I'd much appreciate
> it!
> 

I think I'm wearing holes in my platters. This is being a swine to hit, but I finally got some..
It seems to respond to a combination of high cpu usage and relatively high disk utilisation.

I tried all sorts of acrobatics with multiple readers and hammering the array while reading from 
individual drives..

The only reliable way I can reproduce this seems to be on a degraded array running a "while true ; 
do md5sum -c md5 ; done" on about a 180GB directory of files. It is taking anywhere from 4 to 96 
hours to hit it though.. but at least it's reproducible.


[105449.653682] cfq: rbroot not empty, but ->next_rq == NULL! Fixing up, report the issue to 
lkml@vger.kernel.org
[105449.683646] cfq: busy=1,drv=0,timer=0
[105449.694871] cfq rr_list:
[105449.702715]   3108: sort=0,next=00000000,q=0/1,a=1/0,d=0/0,f=69
[105449.720693] cfq busy_list:
[105449.729054] cfq idle_list:
[105449.737418] cfq cur_rr:
[115435.022192] cfq: rbroot not empty, but ->next_rq == NULL! Fixing up, report the issue to 
lkml@vger.kernel.org
[115435.052160] cfq: busy=1,drv=0,timer=0
[115435.063383] cfq rr_list:
[115435.071227]   3196: sort=0,next=00000000,q=0/1,a=1/0,d=0/0,f=69
[115435.089205] cfq busy_list:
[115435.097566] cfq idle_list:
[115435.105930] cfq cur_rr:
[115616.651883] cfq: rbroot not empty, but ->next_rq == NULL! Fixing up, report the issue to 
lkml@vger.kernel.org
[115616.681848] cfq: busy=1,drv=0,timer=0
[115616.693071] cfq rr_list:
[115616.700916]   3196: sort=0,next=00000000,q=0/1,a=1/0,d=0/0,f=61
[115616.718893] cfq busy_list:
[115616.727253] cfq idle_list:
[115616.735617] cfq cur_rr:
[119679.564753] cfq: rbroot not empty, but ->next_rq == NULL! Fixing up, report the issue to 
lkml@vger.kernel.org
[119679.594732] cfq: busy=1,drv=0,timer=0
[119679.605955] cfq rr_list:
[119679.613799]   3241: sort=0,next=00000000,q=0/1,a=1/0,d=0/0,f=69
[119679.631778] cfq busy_list:
[119679.640136] cfq idle_list:
[119679.648502] cfq cur_rr:

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
