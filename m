Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbZHGIXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbZHGIXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbZHGIXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:23:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025AbZHGIXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:23:22 -0400
Date: Fri, 7 Aug 2009 10:23:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
Message-ID: <20090807082318.GA23910@elte.hu>
References: <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu> <4A7B68C3.7040706@inria.fr> <20090807063226.GA29532@elte.hu> <4A7BD9EC.8000801@inria.fr> <20090807074525.GA20292@elte.hu> <4A7BE35F.4060604@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7BE35F.4060604@inria.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Ingo Molnar wrote:
> > I completely forgot about it. And since we now have --scale enabled 
> > by default (and it doesnt make much sense to disable it i guess), it 
> > would not be a big issue to rename that -c/--scale to free up that 
> > flag for -S/--stat?
> >
> > 	Ingo
> >   
> 
> 
> Here you are. But how do you switch "scale" off now that it's 
> disabled by default? I tried --scale=0, --no-scale and so on 
> without apparently succeeding.

--no-scale seems to work here:

aldebaran:~> perf stat --no-scale -e 0:0 -e 0:0 -e 0:0 -e 0:0 -e 0:0 
-e 0:0 -e 0:0 -e 0:0 ~/loop_1b_instructions

 Performance counter stats for '/home/mingo/loop_1b_instructions':

      469128160  cycles                  
      469072870  cycles                  
      470517049  cycles                  
      473750835  cycles                  
      476987439  cycles                  
      477364955  cycles                  
      474188871  cycles                  
      470950809  cycles                  

    0.237171581  seconds time elapsed

aldebaran:~> perf stat --scale -e 0:0 -e 0:0 -e 0:0 -e 0:0 -e 0:0 -e 
0:0 -e 0:0 -e 0:0 ~/loop_1b_instructions

 Performance counter stats for '/home/mingo/loop_1b_instructions':

      756242908  cycles                    (scaled from 62.00%)
      756238670  cycles                    (scaled from 62.00%)
      756237417  cycles                    (scaled from 62.23%)
      756093940  cycles                    (scaled from 62.66%)
      756097133  cycles                    (scaled from 63.08%)
      756141523  cycles                    (scaled from 63.10%)
      756142674  cycles                    (scaled from 62.68%)
      756154220  cycles                    (scaled from 62.26%)

    0.236972028  seconds time elapsed

	Ingo
