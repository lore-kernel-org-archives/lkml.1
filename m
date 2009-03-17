Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZCQTpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZCQTpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZCQTpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:45:03 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:53681 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZCQTpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:45:00 -0400
Date: Tue, 17 Mar 2009 15:41:53 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall fla
In-Reply-To: <alpine.DEB.2.00.0903161512120.26565@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903171532140.1831@qirst.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com> <alpine.DEB.1.10.0903101651480.20363@qirst.com> <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121145510.27660@qirst.com>
 <alpine.DEB.2.00.0903121137320.1514@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121510380.21607@qirst.com> <alpine.DEB.2.00.0903121224430.5306@chino.kir.corp.google.com> <alpine.DEB.1.10.0903131630530.1741@qirst.com> <alpine.DEB.2.00.0903131620200.1881@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903161239450.17730@qirst.com> <alpine.DEB.2.00.0903161512120.26565@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, David Rientjes wrote:

> Here is my example (for the third time) if, for example, mems are grouped
> by the cpus for which they have affinity:

Well I wish I had been send the messages the first two times.

> /dev/cpuset
> 	--> cpuset_A (cpus 0-1, mems 0-3)
> 	--> cpuset_B (cpus 2-3, mems 4-7)
> 	--> cpuset_C (cpus 4-5, mems 8-11)
> 	--> ...

A cpu can only be assigned to a single numa node. cpuset_A/B/C have 2
cpus but 4 nodes. What is the mapping of nodes to cpus?

> Within that, we isolate mems for specific jobs:
>
> /dev/cpuset
> 	--> cpuset_A (cpus 0-1, mems 0-3)
> 		--> job_1 (mem 0)
> 		--> job_2 (mem 1-2)
> 		--> job_3 (mem 3)
> 	--> ...

Nobody would do that since usually multiple cpus are associated with a
single node. Memory and processors are assigned together in order to
reduce latencies. Randomly assigning processors to nodes will cause
latencies and significant traffic on the interconnect. This does not look
sane and would not be optimized in any way.

Are these memoryless nodes? What are you trying to accomplish?

