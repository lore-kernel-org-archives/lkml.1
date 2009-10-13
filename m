Return-Path: <linux-kernel-owner+w=401wt.eu-S933863AbZJMPWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbZJMPWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760188AbZJMPWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:22:34 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:49084 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755752AbZJMPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:22:33 -0400
Date: Tue, 13 Oct 2009 11:14:28 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] this_cpu: Use this_cpu_xx in trace_functions_graph.c
In-Reply-To: <4AD49559.5050707@kernel.org>
Message-ID: <alpine.DEB.1.10.0910131110110.8088@gentwo.org>
References: <20091013144812.bdb376aa.sfr@canb.auug.org.au> <4AD48EC4.8040701@kernel.org> <alpine.DEB.1.10.0910131035450.11413@gentwo.org> <4AD49317.6080503@kernel.org> <alpine.DEB.1.10.0910131043460.8088@gentwo.org> <4AD49559.5050707@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Tejun Heo wrote:

> > For this_cpu_ptr / __this_cpu_ptr it does not matter. this_cpu_ptr gives
> > you additional checks.
>
> Yes, you're right.  The naming scheme in percpu sucks really hard.
> The subtle differences among [__]get_cpu_var(), [__]this_cpu_ptr() and
> other this_cpu ops.  Arghhhhhh.......

Yeah. __this_cpu_ptr is safe to use in preempt / irq disable sections
though the same way as __this_cpu_add/dec etc.

(__)get_cpu_var can be mostly gotten rid off through __this_cpu
operations.

We could define __get_cpu_var and get_cpu_var using this_cpu

#define get_cpu_var(x) (get_cpu(); this_cpu_read(per_cpu_var(x))

#define __get_cpu_var __this_cpu_read(per_cpu_var(x))


