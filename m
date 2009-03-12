Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbZCLQTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbZCLQTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbZCLQSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:18:53 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:37746 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbZCLQSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:18:52 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 12:18:52 EDT
Date: Thu, 12 Mar 2009 11:47:32 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903121145510.27660@qirst.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com> <alpine.DEB.1.10.0903101651480.20363@qirst.com> <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, David Rientjes wrote:

> > The description is not accurate. This feature is only useful if someone
> > comes up with a crummy cpuset definition in which a processor is a member
> > of multiple cpusets and thus the per cpu queues of multiple subsystems get
> > objects depending on which cpuset is active.
> >
>
> Cpusets are hierarchical, so it is quite possible that a parent cpuset
> will include a group of cpus that has affinity to a specific group of
> mems.  This isolates that cpuset and all of its children for NUMA
> optimiziations.  Within that, there can be several descendant cpusets that
> include disjoint subsets of mems to isolate the memory that can be used
> for specific jobs.

Yes cpusets are hierachical for management purposes but it is well known
that overlaying cpusets for running applications can cause issues with the
scheduler etc. Jobs run in the leaf not in the higher levels that may
overlap.
