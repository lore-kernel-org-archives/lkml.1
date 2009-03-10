Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZCJVLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZCJVLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbZCJVKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:10:54 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:33914 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755821AbZCJVKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:10:53 -0400
Date: Tue, 10 Mar 2009 16:59:05 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903101651480.20363@qirst.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, David Rientjes wrote:

> This interface is lockless and very quick in the slab allocator fastpath
> when not enabled because a new task flag, PF_SLAB_HARDWALL, is added to
> determine whether or not its cpuset has mandated objects be allocated on
> the set of allowed nodes.  If the option is not set for a task's cpuset
> (or only a single cpuset exists), this reduces to only checking for a
> specific bit in current->flags.

We already have PF_SPREAD_PAGE PF_SPREAD_SLAB and PF_MEMPOLICY.
PF_MEMPOLICY in slab can have the same role as PF_SLAB_HARDWALL. It
attempts what you describe. One the one hand you duplicate functionality
that is already there and on the other you want to put code in the hot
paths that we have intentionally avoided for ages.

The description is not accurate. This feature is only useful if someone
comes up with a crummy cpuset definition in which a processor is a member
of multiple cpusets and thus the per cpu queues of multiple subsystems get
objects depending on which cpuset is active.

If a processor is only used from one cpuset (natural use) then these
problems do not occur.

There is still no use case for this on a NUMA platform. NUMA jobs that I
know about where people care about latencies have cpusets that do not
share processors and thus this problem does not occur.

