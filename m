Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbZCLQZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbZCLQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbZCLQXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:23:53 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:41383 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535AbZCLQXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:23:52 -0400
Date: Thu, 12 Mar 2009 11:51:56 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Paul Menage <menage@google.com>
cc: David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <6599ad830903101512g16a8eda3w959123e71c225960@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0903121147480.27660@qirst.com>
References: <20090309123011.A228.A69D9226@jp.fujitsu.com>  <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com>  <20090309181756.CF66.A69D9226@jp.fujitsu.com>  <alpine.DEB.2.00.0903091313090.27253@chino.kir.corp.google.com> 
 <alpine.DEB.1.10.0903091706540.1861@qirst.com>  <alpine.DEB.2.00.0903091422510.5410@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903101649330.20363@qirst.com> <6599ad830903101512g16a8eda3w959123e71c225960@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Paul Menage wrote:

> We definitely  have real workloads where a job is allocating lots of
> slab memory (e.g. network socket buffers, dentry/inode objects, etc)
> and we want to be able to account the memory usage to each job rather
> than having all the slab scattered around unidentifiably, and to
> reduce fragmentation (so when a job finishes, all its sockets close
> and all its files are deleted, there's a better chance that we'll be
> able to reclaim some slab memory). We could probably turn those into
> more synthetic benchmarkable loads if necessary for demonstration.

So this is about memory accounting? The kernel tracks all memory used by a
process and releases it independantly from this patch.

The resources that you are mentioning are resources that are typically
shared by multiple processes. There no task owning these items. It is
accidental that a certain process is exclusively using one of these at a
time.

The real workloads are running in cpusets that are overlapping? Why would
this be done? The point of cpusets is typically to segment the
processors for a certain purpose.



