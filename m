Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZCMUge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZCMUge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 16:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZCMUgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 16:36:25 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:54336 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZCMUgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 16:36:25 -0400
Date: Fri, 13 Mar 2009 16:34:41 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.2.00.0903121224430.5306@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903131630530.1741@qirst.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com> <alpine.DEB.1.10.0903101651480.20363@qirst.com> <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121145510.27660@qirst.com>
 <alpine.DEB.2.00.0903121137320.1514@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121510380.21607@qirst.com> <alpine.DEB.2.00.0903121224430.5306@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, David Rientjes wrote:

> If `memory_slab_hardwall' is set for a cpuset, its tasks will only pull a
> slab off the partial list that was allocated on an allowed node.  So in my
> earlier example which segments the machine via cpusets for NUMA locality
> and then divides those cpusets further for exclusive memory to provide to
> individual jobs, slab allocations will be constrained within the cpuset of
> the task that allocated them.  When a job dies, all slab allocations are
> freed so that no objects remain on the memory allowed to that job and,
> thus, no partial slabs remain (i.e. there were no object allocations on
> the job's slabs from disjoint cpusets because of the exclusivity).

In order to do that you would need to duplicate the partial lists for
each job and then guarantee that only the job uses objects from these
partial pages.

Usually some partial allocated pages are kept around and are
indiscriminately used by various system components by the OS due to other
processing. Creating partial slabs cannot be avoided like that.





