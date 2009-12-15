Return-Path: <linux-kernel-owner+w=401wt.eu-S932198AbZLOOPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbZLOOPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760304AbZLOOPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:15:41 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52474 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbZLOOPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:15:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uCRl80zbf7UnfgUuKpmlq/Pwy5ZLhMxuVXO0qrYSYITZjHYhsKG01gJzx11+GNeH4F
         Z3ZfCVjmoIzSP1KrQt0S7hJ6MJo34yvLuGQpD9PRd5DAQhjnoqJ9NjV7ImtXXkau2sre
         /jYxEqYf82bR25Xmp1YXYnliqvlEj/19fDoA8=
Date: Tue, 15 Dec 2009 15:15:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf_event: introduce 'perf timer' to analyze
	timer's behavior
Message-ID: <20091215141533.GB5833@nowhere>
References: <4B27702F.1080507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27702F.1080507@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 07:17:03PM +0800, Xiao Guangrong wrote:
> Hi,
> 
> We introduce 'perf timer' in this patchset, it can analyze timer
> latency and timer function handle time, the usage and result is
> like below:
> 
> # perf timer record
> # perf timer lat --print-lat --print-handle
> -------------------------------------------------------------------------------------------------------
> |   Timer            |   TYPE   |   Avg-latency  | Max-latency  |  Max-latency-at-TS |Max-lat-at-Task |
> |0xf7ad1f5c          |hrtimer   |996068.500    ns|1607650     ns|10270128658526      |init            |
> |0xf7903f04          |timer     |0.625         HZ|2           HZ|10270344082394      |swapper         |
> |0xf787a05c          |hrtimer   |200239.500    ns|359929      ns|10269316024808      |main            |
> |main      :[   PROF]|itimer    |0.000         HZ|0           HZ|10237021270557      |main            |
> |main      :[VIRTUAL]|itimer    |0.000         HZ|0           HZ|10257314773501      |main            |



Cool! This is really a good work and a good idea.

Just have some neats in mind. hrtimers and timers don't have the same latency and
granularity requirements.

As you show it, timers have an HZ granularity and hrtimers are about nanoseconds,
and mixing them up in the same array of latency report is too messy.
They don't have the same granularity/latency scope so they should
be reported separately.

Otherwise it's like mixing slothes and flies latency results after
a fly swat attack test ;-)

