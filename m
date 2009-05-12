Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZELRSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZELRSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZELRSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:18:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:56299 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZELRSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:18:31 -0400
Message-ID: <4A09AEFB.4070808@kernel.org>
Date: Tue, 12 May 2009 10:16:43 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/3] x86: add numa_move_cpus_to_node
References: <4A05269D.8000701@kernel.org> <4A052721.4010201@kernel.org> <alpine.DEB.1.10.0905112126410.28512@qirst.com> <4A089E53.8010106@kernel.org> <alpine.DEB.1.10.0905121658140.14226@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0905121658140.14226@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 11 May 2009, Yinghai Lu wrote:
> 
>>> This going to be fun for the allocators that have put their queues on the
>>> respective nodes. How are the various OS structures that were allocated on
>>> the node that is downed / upped relocated?
>> NODE_DATA is new allocated on that node is backed on line for the first time.
>>
>> per_cpu will still stay with old near node. because per_cpu is somehow preallocated for all possible cpu.
> 
> Slab allocators and page allocator use neither NODE_DATA nor percpu
> 
> It may be best to bring the processors down and up again if the node
> assignment changes. That will cause the allocators to reallocate the per
> cpu resources on the right node.

or let user util do that? aka before hotadd mem to that node, use /sys to bring
the cpu offine and put the cpus online after mem is added ?

YH
