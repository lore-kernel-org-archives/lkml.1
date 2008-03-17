Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYCQFfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYCQFfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 01:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYCQFfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 01:35:00 -0400
Received: from n72.bullet.mail.sp1.yahoo.com ([98.136.44.34]:47643 "HELO
	n72.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752185AbYCQFe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 01:34:58 -0400
X-Yahoo-Newman-Id: 784051.37301.bm@omp412.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KuV2MVlb+cGYh/WvpwVuSv1/MSL0RJa/dQlYW4zdyzOboKEwfxckUxBBxCFbKsTQQC2tpW26XBFwQ+PSKKrlY++7yrubfMwM0XPHeRUUv/nX34tgMxGHzBsv6yhtCCMw/Jg016bHT+VsUrDKGNb27ziKSZ82cbfzW79LA88mzcM=  ;
X-YMail-OSG: iJBNY3UVM1mHWB3VYaQHmL2QJRMTxN8qchfNP_ZIgkJMFDnBVklc4f7MTjhenVOaIeOvxBFo1w--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Date: Mon, 17 Mar 2008 16:34:45 +1100
User-Agent: KMail/1.9.5
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "LKML," <linux-kernel@vger.kernel.org>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <200803171144.35479.nickpiggin@yahoo.com.au> <2c0942db0803162216r1892782bsc894d4188b51481b@mail.gmail.com>
In-Reply-To: <2c0942db0803162216r1892782bsc894d4188b51481b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171634.46295.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008 16:16, Ray Lee wrote:
> On Sun, Mar 16, 2008 at 5:44 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> >  I don't see how it is really helpful for interactive processes either.
> >  By definition, if they are not CPU bound, then they should be run
> >  quite soon after waking up; if they are CPU bound, then reducing
> >  efficiency by increasing context switches is effectively going to
> >  increase their latency anyway.
>
> How? Are you saying that switching the granularity to, say, 25ms, will
> *decrease* the latency of interactive tasks?

No. It shouldn't change them.


> And the efficiency we're talking about reducing here is due to the
> fact that tasks are hitting cold caches more times per second when the
> granularity is smaller, correct? Or are you concerned by another
> issue?

Secondary issues like the actual cost of context switch, but they are
generally in the noise compared to cache and tlb costs.


> > Can this be changed by default, please?
>
> Not without benchmarks of interactivity, please. There are far, far
> more linux desktops than there are servers. People expect to have to
> tune servers (I do, for the servers I maintain). People don't expect
> to have to tune a desktop to make it run well.

Linux desktops shouldn't run with massive loads anyway. Tuning the
scheduler to "work" well in an X session when you have a make -j100
in the background is retarded.

But sure, if the scheduler doesn't properly prioritize non-CPU bound
tasks versus CPU bound ones, then it should be fixed to do so.

