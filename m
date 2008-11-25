Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYKYVVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYKYVVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYKYVVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:21:33 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43655 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYKYVVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:21:32 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 25 Nov 2008 13:19:54 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, ltt-dev@lists.casi.polymtl.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [PATCH] Poll : introduce poll_wait_exclusive() new function
In-Reply-To: <20081125194700.26EB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0811251316590.32523@alien.or.mcafeemobile.com>
References: <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081124121659.GA18987@Krystal> <20081125194700.26EB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008, KOSAKI Motohiro wrote:

> 
> patch againt: tip/tracing/marker
> 
> ==========
> Currently, wake_up() function behavior depend on the way of
> wait queue adding function.
> 
> 
>                               wake_up()          wake_up_all()
> ---------------------------------------------------------------
> add_wait_queue()              wake up all        wake up all
> add_wait_queue_exclusive()    wake up one task   wake up all
> 
> 
> Unforunately, poll_wait() always use add_wait_queue().
> it means there is no way that wake up only one process in polled processes.
> wake_up() also wake up all sleeping processes, not 1 process.
> 
> 
> Mathieu Desnoyers explained it cause following problem to LTTng.
> 
>    In LTTng, all lttd readers are polling all the available debugfs files
>    for data. This is principally because the number of reader threads is
>    user-defined and there are typical workloads where a single CPU is
>    producing most of the tracing data and all other CPUs are idle,
>    available to consume data. It therefore makes sense not to tie those
>    threads to specific buffers. However, when the number of threads grows,
>    we face a "thundering herd" problem where many threads can be woken up
>    and put back to sleep, leaving only a single thread doing useful work.

Why do you need to have so many threads banging a single device/file?
Have one (or any other very little number) puller thread(s), that 
activates with chucks of pulled data the other processing threads. That 
way there's no need for a new wakeup abstraction.



- Davide


