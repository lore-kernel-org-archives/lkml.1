Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbYEHHjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbYEHHjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbYEHHjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:39:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42820 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbYEHHjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:39:42 -0400
Date: Thu, 8 May 2008 09:39:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080508073924.GA30356@elte.hu>
References: <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <20080508064340.GA27452@elte.hu> <1210230883.3453.127.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210230883.3453.127.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> > great! Yanmin, could you please also check the other patch i sent 
> > (also attached below), does it solve the regression similarly?
>
> With your patch, aim7 regression becomes less than 2%. I ran the 
> testing twice.
> 
> Linus' patch could recover it completely. As aim7 result is quite 
> stable(usually fluctuating less than 1%), 1.5%~2% is a little big.

is this the old original aim7 you are running, or osdl-aim-7 or 
re-aim-7?

if it's aim7 then this is a workload that starts+stops 2000 parallel 
tasks that each start and exit at the same time. That might explain its 
sensitivity on the BKL - this is all about tty-controlled task startup 
and exit.

i could not get it to produce anywhere close to stable results though. I 
also frequently get into this problem:

  AIM Multiuser Benchmark - Suite VII Run Beginning
  Tasks    jobs/min  jti  jobs/min/task      real       cpu
   2000
  Failed to execute
          new_raph 200
  Unable to solve equation in 100 tries. P = 1.5708, P0 = 1.5708, delta = 6.12574e-17

  Failed to execute
          disk_cp /mnt/shm
  disk_cp (1): cannot open /mnt/shm/tmpa.common
  disk1.c: No such file or directory

  [.. etc. a large stream of them .. ]

system has 2GB of RAM and tmpfs mounted to the place where aim7 puts its 
work files.

	Ingo
