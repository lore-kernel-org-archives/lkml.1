Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbZCLQ2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbZCLQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbZCLQ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:28:06 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:45238 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbZCLQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:28:05 -0400
Date: Thu, 12 Mar 2009 12:08:11 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Matt Mackall <mpm@selenic.com>
cc: David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <1236719283.3205.24.camel@calx>
Message-ID: <alpine.DEB.1.10.0903121206250.5493@qirst.com>
References: <20090309123011.A228.A69D9226@jp.fujitsu.com>  <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com>  <20090309181756.CF66.A69D9226@jp.fujitsu.com>  <alpine.DEB.2.00.0903091313090.27253@chino.kir.corp.google.com> 
 <alpine.DEB.1.10.0903091706540.1861@qirst.com>  <alpine.DEB.2.00.0903091422510.5410@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903101649330.20363@qirst.com> <1236719283.3205.24.camel@calx>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Matt Mackall wrote:

> > > Yes, and that's why we require the cpuset hardwall on a configurable
> > > per-cpuset basis.  If a cpuset has set this option for its workload, then
> > > it is demanding object allocations from local memory.  Other cpusets that
> > > do not have memory_slab_hardwall set can still allocate from any cpu slab
> > > or partial slab, including those allocated for the hardwall cpuset.
> >
> > You cannot hardwall something that is used in a shared way by processes in
> > multiple cpusets.
>
> He can enforce that every allocation made when a given task is current
> conforms. His patch demonstrates that.

Of course. But that may just be a subset of the data used by a task. If an
inode, dentry and so on was already allocated in the context of another
process then the locality of that allocation will not be changed. The
hardwall will have no effect.


