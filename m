Return-Path: <linux-kernel-owner+w=401wt.eu-S1762804AbYDVLLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762804AbYDVLLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 07:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbYDVLK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 07:10:59 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:55248 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbYDVLK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 07:10:59 -0400
Subject: Re: [git pull] scheduler changes for v2.6.26
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: kjwinchester@gmail.com, mingo@elte.hu, elendil@planet.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, efault@gmx.de, richie@coderworld.net,
       rjw@sisk.pl
In-Reply-To: <20080422.034935.134139117.davem@davemloft.net>
References: <200804211831.29976.elendil@planet.nl>
	 <20080421194359.GD8770@elte.hu> <480DB2DB.9040908@gmail.com>
	 <20080422.034935.134139117.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 13:10:54 +0200
Message-Id: <1208862654.7115.228.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 03:49 -0700, David Miller wrote:
> From: Kevin Winchester <kjwinchester@gmail.com>
> Date: Tue, 22 Apr 2008 06:41:47 -0300
> 
> > kevin@alekhine:~/linux$ ./watch-rq-clock.sh
> > 89.986517
> > 81.033471
> > 76.942776
> > 90.986318
> > 75.988551
> > 85.987089
> > 74.988696
> > 85.987078
> > 73.988858
> > 88.986641
> > 68.989600
> 
> The results on my 128-cpu Niagara2 box are even more interesting:
> 
> davem@maramba:~$ /bin/bash ./watch-rq-clock.sh 
> 0
> 0
> 0
> 0
> 0
> 0
> 0
> 0
> 0
> 0
> 0
> 0
> 0
> ....
> 
> I guess this script doesn't work correctly when the cpu
> whose clock value it greps out of /proc/sched_debug is
> in NOHZ mode?

Yeah - looking at the script it seems to look at the last one, so if
indeed that cpu is fully idle its rq clock will be stalled.

The fix that went in right after .25 was that when it came out of nohz
mode rq->clock could catch up 1 jiffy even though it had been out much
longer.

So the interesting thing to know is whether rq->clock properly accounts
for all idle time when the cpu leaves idle mode.


