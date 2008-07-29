Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYG2PDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYG2PDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYG2PDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:03:39 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42837 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750886AbYG2PDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:03:38 -0400
Message-ID: <488F3148.2050500@sgi.com>
Date: Tue, 29 Jul 2008 08:03:36 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: cpu4096 + smp_affinity breakage
References: <488F2A65.2090405@gmail.com>
In-Reply-To: <488F2A65.2090405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Hi,
> 
> I see cpu4096 branches in -tip. Do you know about
> /proc/irq/*/*smp_affinity (irq_affinity_read_proc,
> default_affinity_read) breakage with NR_CPUS=4096? Reading by `cat' from
> those files fails due to bitmap sent out is about 1150 bytes, but cat
> provides only 1024B sized buffer. Can you think about any fix for this?
> 
> Using file offset and utilize only portion of that buffer returned to
> the userspace will break atomicity I guess (does this matter?). If we
> get a snapshot, it would get old if some reader breaks up. And if we use
> per-reader buffer, we will be unable to free it. Any ideas?
> 
> I think the same problem is for not-at-once-writes.

The best alternate is to use cpulist_scnprintf but even this has
problems in the worst pathological case (where you want every other
cpu listed, e.g. only one of the two hyper threads).  Another alternate
would be to send only nr_cpu_ids mask bits [with obviously some way
for the user to discover what nr_cpu_ids is.]

There was strong objections to changing any of the /sys interfaces, but
I don't know what the rules are for the /proc interfaces.  And (iirc),
overflow was the user's responsibility.  How about using "dd bs=4k ..."?

Thanks,
Mike
