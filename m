Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbZJMO6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbZJMO6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760115AbZJMO6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:58:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:48905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760024AbZJMO6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:58:30 -0400
Message-ID: <4AD49559.5050707@kernel.org>
Date: Tue, 13 Oct 2009 23:57:29 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] this_cpu: Use this_cpu_xx in trace_functions_graph.c
References: <20091013144812.bdb376aa.sfr@canb.auug.org.au> <4AD48EC4.8040701@kernel.org> <alpine.DEB.1.10.0910131035450.11413@gentwo.org> <4AD49317.6080503@kernel.org> <alpine.DEB.1.10.0910131043460.8088@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910131043460.8088@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 14:57:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 13 Oct 2009, Tejun Heo wrote:
> 
>> Oh... one question tho.  I used __this_cpu_*() as other conversions
>> but I think we should be using the version without the underscores.
>> The relationship between get_cpu_var() and __get_cpu_var() is
>> different from the one between this_cpu_*() and __this_cpu_*().
> 
> For operations like inc/add/dec/sub you need to use the version with __
> otherwise the arches that do not support these operations will have to
> generate useless expensive code that disables / reenables preempt.
> 
> For this_cpu_ptr / __this_cpu_ptr it does not matter. this_cpu_ptr gives
> you additional checks.

Yes, you're right.  The naming scheme in percpu sucks really hard.
The subtle differences among [__]get_cpu_var(), [__]this_cpu_ptr() and
other this_cpu ops.  Arghhhhhh.......

-- 
tejun
