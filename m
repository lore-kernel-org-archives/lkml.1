Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbYJ1D6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbYJ1D6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 23:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYJ1D6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 23:58:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53629 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbYJ1D6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 23:58:34 -0400
Message-ID: <49068D2A.9010308@cn.fujitsu.com>
Date: Tue, 28 Oct 2008 11:55:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: ltt-dev@lists.casi.polymtl.ca, "Martin J. Bligh" <mbligh@mbligh.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, kernel-trace-list@redhat.com,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com
Subject: Re: [ltt-dev] LTTng 0.44 and LTTV 0.11.3
References: <20081024004502.GA21759@Krystal>
In-Reply-To: <20081024004502.GA21759@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> - I have also vastly simplified locking in the markers and tracepoints
>   by using _only_ the modules mutex. I actually took this mutex out of
>   module.c and created its own file so tracepoints and markers can use
>   it. That should please Lai Jiangshan. Although he may have some work
>   to do to see how his new probes manager might benefit from it.
> 
>   See :
>   http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=7aea87ac46df7613d68034f5904bc8d575069076
>   and
>   http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=5f6814237f7a67650e7b6214d916825e3f8fc1b7
>   http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=410ba66a1cbe27a611e1c18c0a53e87b4652a2c9
> 

Hi, Mathieu,

I strongly reject for removing tracepoint_mutex and marker_mutex.

As an independent subsystem, we should use our own locks. Do not use others.
otherwise coupling will be increased in linux kernel.
I condemn unnecessary coupling.

Our tracepoint & marker had tied to modules(for traveling all tracepoints
or markers). The best thing is that we do not increase the coupling.

[PATCH 2/2] tracepoint: introduce *_noupdate APIs.
is helpful for auto-active-tracepoint-mechanism.

		Thanx, Lai.

> So hopefully everyone will be happy with this new release. :)
> 
> Mathieu
> 


