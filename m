Return-Path: <linux-kernel-owner+w=401wt.eu-S965365AbZLHBdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965365AbZLHBdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965298AbZLHBdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:33:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52418 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965296AbZLHBdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:33:03 -0500
Message-ID: <4B1DAC6E.8000605@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 09:31:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for	analyzing
 lock statistics
References: <20091115022135.GA5427@nowhere> <1260156884-8474-2-git-send-email-mitake@dcl.info.waseda.ac.jp> <20091207044125.GB5262@nowhere> <20091207072752.GG10868@elte.hu> <4B1CBEEB.3090800@cn.fujitsu.com> <20091207194802.GB5049@nowhere>
In-Reply-To: <20091207194802.GB5049@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

Frederic Weisbecker wrote:

> This profile has been done using ftrace with perf right?

We not use perf, just operate it by debugfs, the test procedure
is like below:

case 1: disable all trace events:
echo nop > debugfs/tracing/current_tracer
echo > debugfs/tracing/set_event
run benchmarks
...

case 2: enable all trace events except lockdep:
echo nop > debugfs/tracing/current_tracer
echo *:* > debugfs/tracing/set_event
echo 0 >  debugfs/tracing/events/lockdep/enable
run benchmarks
...

> In one of your previous mails, you showed us the difference
> of the size of perf.data by capturing either scheduler events
> or lock events.
> 

It's not my work :-)

Thanks,
Xiao

> And IIRC, the case of lock events resulted in a 100 MB perf.data
> whereas it was a small file for sched events.
> 
> The overhead in the pagefault and mmap latency could then
> result in the fact we have much more events to save, walking
> through much more pages in perf buffer, then faulting more often,
> etc.
> 
> Plus the fact various locks are taken in mmap and fault path,
> generating more lock events.
> 
> Just a guess...
> 
> 
> 

