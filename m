Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZCLTYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZCLTYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZCLTYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:24:25 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:49150 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbZCLTYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:24:24 -0400
Date: Thu, 12 Mar 2009 15:12:14 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.2.00.0903121137320.1514@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903121510380.21607@qirst.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com> <alpine.DEB.1.10.0903101651480.20363@qirst.com> <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121145510.27660@qirst.com>
 <alpine.DEB.2.00.0903121137320.1514@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, David Rientjes wrote:

> Yes, jobs are running in the leaf with my above example.  And it's quite
> possible that the higher level has segmented the machine for NUMA locality
> and then further divided that memory for individual jobs.  When a job
> completes or is killed, the slab cache that it has allocated can be freed
> in its entirety with no partial slab fragmentation (i.e. there are no
> objects allocated from its slabs for disjoint, still running jobs).  That
> cpuset may then serve another job.

Looks like we are talking about a differing project here. Partial slabs
are shared between all processors with SLUB. Slab shares the partial slabs
for the processors on the same node.


