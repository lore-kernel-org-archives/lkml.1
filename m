Return-Path: <linux-kernel-owner+w=401wt.eu-S1751402AbXBMSDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbXBMSDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXBMSDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:03:32 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:37800 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751402AbXBMSDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:03:31 -0500
Date: Tue, 13 Feb 2007 10:03:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andi Kleen <ak@suse.de>
cc: "Martin J. Bligh" <mbligh@mbligh.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
In-Reply-To: <200702131845.05913.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0702130956540.26309@schroedinger.engr.sgi.com>
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
 <45D1F0B1.3020508@mbligh.org> <200702131845.05913.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Andi Kleen wrote:

> Adding NULL tests all over mm for this would seem like a clear case
> of this to me.

Maybe there is an alternative. We are free to number the nodes right? 
How about requiring the low node number to have memory and the high ones 
do not?

F.e. have a boundary like

nr_mem_nodes ?

Everything above nr_mem_nodes has no memory and cannot be specified in a 
nodemask. Those nodes would not be visible to user space via memory 
policies and page migration. So the core mempolicy logic could be left 
untouched.

The nodes above nr_mem_nodes would exist purely within the kernel. They 
would have proximity information (which can be used to determine 
neighboring memory. More flexible then the current attachment 
to one fixed memory node) but those node numbers could not be specified as 
node masks in any memory operations. This would then allow memory less nodes 
with I/O or cpus. The user would not be aware of these.

