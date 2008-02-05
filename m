Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbYBEHuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbYBEHuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbYBEHuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:50:00 -0500
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:38346
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbYBEHt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:49:59 -0500
Message-ID: <47A81513.4010301@cosmosbay.com>
Date: Tue, 05 Feb 2008 08:49:39 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg a écrit :
> Hi Christoph,
> 
> On Mon, 4 Feb 2008, Christoph Lameter wrote:
>> The statistics provided here allow the monitoring of allocator behavior
>> at the cost of some (minimal) loss of performance. Counters are placed in
>> SLUB's per cpu data structure that is already written to by other code.
> 
> Looks good but I am wondering if we want to make the statistics per-CPU so 
> that we can see the kmalloc/kfree ping-pong of, for example, hackbench 
> better?

AFAIK Christoph patch already have percpu statistics :)


+#define STAT_ATTR(si, text) 					\
+static ssize_t text##_show(struct kmem_cache *s, char *buf)	\
+{								\
+	unsigned long sum  = 0;					\
+	int cpu;						\
+								\
+	for_each_online_cpu(cpu)				\
+		sum += get_cpu_slab(s, cpu)->stat[si];		\
+	return sprintf(buf, "%lu\n", sum);			\
+}								\

