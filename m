Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZIVRQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZIVRQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZIVRQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:16:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47215 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbZIVRQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:16:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=KJZ5OlOojF1CGYZvhmRpRsc6qmsECuzJk/Bv+Fn2ZRBIf5Yj6rpyjQvLt3k6NlhM5
	FEoLbVm/EOGraAvBxTEuw==
Date: Tue, 22 Sep 2009 10:16:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "mingo@elte.hu" <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: fix cpumask_of_pcibus() to handle nid of -1
In-Reply-To: <1253597220.2519.4.camel@sbs-t61>
Message-ID: <alpine.DEB.1.00.0909221014240.7114@chino.kir.corp.google.com>
References: <1253597220.2519.4.camel@sbs-t61>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, Suresh Siddha wrote:

> On my two socket NHM-EP system, with CONFIG_DEBUG_PER_CPU_MAPS=y I see:
> 
>   cpumask_of_node(-1): no node_to_cpumask_map!
>   Pid: 5635, comm: irqbalance Not tainted 2.6.31-07068-g43c1266-dirty #145
>   Call Trace:
>    [<ffffffff81031033>] cpumask_of_node+0x4f/0x58
>    [<ffffffff811b5a8c>] local_cpus_show+0x1f/0x48
>    [<ffffffff812c3c65>] dev_attr_show+0x20/0x44
>    [<ffffffff810fcade>] sysfs_read_file+0xb2/0x131
>    [<ffffffff810b2702>] vfs_read+0xab/0x147
>    [<ffffffff810b2862>] sys_read+0x47/0x6f
>    [<ffffffff8100af6b>] system_call_fastpath+0x16/0x1b
> 
> Fix x86 version of cpumask_of_pcibus() to handle node id of "-1"
> (default value indicating that I/O isn't tied to any particular node).
> 

This is already fixed in -mm with 
x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch and is 
awaiting inclusion via Jesse Barnes' tree.
