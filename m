Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZHJOFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZHJOFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZHJOFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:05:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57969 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752AbZHJOFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:05:18 -0400
Date: Mon, 10 Aug 2009 16:05:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, Brice.Goglin@inria.fr,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf report: Add raw displaying of
	per-thread counters
Message-ID: <20090810140507.GA13540@elte.hu>
References: <4A802008.5050409@inria.fr> <tip-9f8666971185b86615a074bcac67c90fdf8af8bc@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-9f8666971185b86615a074bcac67c90fdf8af8bc@git.kernel.org>
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


* tip-bot for Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Commit-ID:  9f8666971185b86615a074bcac67c90fdf8af8bc
> Gitweb:     http://git.kernel.org/tip/9f8666971185b86615a074bcac67c90fdf8af8bc
> Author:     Brice Goglin <Brice.Goglin@inria.fr>
> AuthorDate: Mon, 10 Aug 2009 15:26:32 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 10 Aug 2009 15:48:17 +0200
> 
> perf report: Add raw displaying of per-thread counters
> 
> If --pretty=raw is given to perf report -T, it now displays one
> line per-thread per-counter with the raw event id added.
> 
> We get:
>  #   PID    TID              Name  Raw    Count
>    18608  18609      cache-misses  28e   416744
>    18608  18609  cache-references  28f  6456792
>    18608  18608      cache-misses  28e   448219
>    18608  18608  cache-references  28f  7270244

btw., this is the full output we do:

aldebaran:~> perf record -f -n -s ./hackbench 1
aldebaran:~> perf report -T --pretty=raw

# Samples: 0
#
# Overhead    Command  Shared Object  Symbol
# ........  .........  .............  ......
#
#
# (For a higher level overview, try: perf report --sort comm,dso)
#

#   PID    TID    Name  Raw     Count
  17937  17937  cycles   3b  11590867
  17935  17935  cycles   3b  11461700
  17942  17942  cycles   3b  10912077
  17927  17927  cycles   3b  10904967
  17924  17924  cycles   3b  13313815
  17934  17934  cycles   3b  11639158
  17939  17939  cycles   3b  10803818
  17931  17931  cycles   3b  11802979
  17925  17925  cycles   3b  11303473
  17926  17926  cycles   3b  12243882
  17936  17936  cycles   3b   9997099
  17938  17938  cycles   3b  11255911
  17932  17932  cycles   3b  11957781
  17929  17929  cycles   3b  12936176
  17933  17933  cycles   3b  12685907
  17930  17930  cycles   3b  12455278
  17928  17928  cycles   3b  13187215
  17940  17940  cycles   3b  15426327
  17923  17923  cycles   3b  15754461
  17903  17903  cycles   3b  11156016
  17905  17905  cycles   3b   9747782
  17904  17904  cycles   3b   8743904
  17907  17907  cycles   3b  10827088
  17906  17906  cycles   3b  10109984
  17908  17908  cycles   3b  11092446
  17909  17909  cycles   3b   8167235
  17910  17910  cycles   3b  12132769
  17911  17911  cycles   3b   9469716
  17912  17912  cycles   3b   9541507
  17914  17914  cycles   3b   8612516
  17913  17913  cycles   3b   9805519
  17915  17915  cycles   3b  10021933
  17916  17916  cycles   3b  10763787
  17917  17917  cycles   3b  10519547
  17918  17918  cycles   3b   9749113
  17919  17919  cycles   3b  10582943
  17921  17921  cycles   3b   8717079
  17920  17920  cycles   3b   9113000
  17922  17922  cycles   3b  12102473
  17941  17941  cycles   3b  15668897
  17902  17902  cycles   3b   9148959

I think we should supress the header portion, as it's highly 
confusing in this case when we dont sample RIPs but only counts, 
right?

	Ingo
