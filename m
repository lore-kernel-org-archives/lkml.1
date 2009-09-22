Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZIVGec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZIVGec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZIVGec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:34:32 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52341 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754803AbZIVGeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:34:31 -0400
Date: Tue, 22 Sep 2009 02:30:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: David Rientjes <rientjes@google.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, heiko.carstens@de.ibm.com,
       sachinp@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
In-Reply-To: <alpine.DEB.1.00.0909211704180.4798@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0909220227050.3719@V090114053VZO-1>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <1253577603.7103.174.camel@pasglop> <alpine.DEB.1.00.0909211704180.4798@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, David Rientjes wrote:

> I disagree that we need kernel support for memoryless nodes on x86 and
> probably on all architectures period.  "NUMA nodes" will always contain
> memory by definition and I think hijacking the node abstraction away from
> representing anything but memory affinity is wrong in the interest of a
> long-term maintainable kernel and will continue to cause issues such as
> this in other subsystems.

Amen. Sadly my past opinions on this did not seem convincing enough.

> I do understand the asymmetries of these machines, including the ppc that
> is triggering this particular hang with slqb.  But I believe the support
> can be implemented in a different way: I would offer an alternative
> representation based entirely on node distances.  This would isolate each
> region of memory that has varying affinity to cpus, pci busses, etc., into
> nodes and then report a distance, whether local or remote, to other nodes
> much in the way the ACPI specification does with proximity domains.

Good idea.

> Using node distances instead of memoryless nodes would still be able to
> represent all asymmetric machines that currently benefit from the support
> by binding devices to memory regions to which they have the closest
> affinity and then reporting relative distances to other nodes via
> node_distance().

How would you deal with a memoryless node that has lets say 4 processors
and some I/O devices? Now the memory policy is round robin and there are 4
nodes at the same distance with 4G memory each. Does one of the nodes now
become priviledged under your plan? How do you equally use memory from all
these nodes?


