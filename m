Return-Path: <linux-kernel-owner+w=401wt.eu-S1423265AbXBHTfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423265AbXBHTfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423267AbXBHTfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:35:45 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:56095 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423265AbXBHTfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:35:44 -0500
Date: Thu, 8 Feb 2007 11:35:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, GOTO <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
In-Reply-To: <20070208112629.3a4ce158.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702081129270.11336@schroedinger.engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
 <p73ejp2mfqh.fsf@bingen.suse.de> <20070207082330.d07525ec.akpm@linux-foundation.org>
 <200702071750.55283.ak@suse.de> <20070207094344.0efdde10.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702081106460.11045@schroedinger.engr.sgi.com>
 <20070208112629.3a4ce158.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Andrew Morton wrote:

> > Surely your computer has some memory so attach it to that memory (which 
> > in a NUMA system would be one or the other node).
> 
> "attach it".  But it _isn't_ attached.  There is no memory on this node. 
> We seem to be saying that we should misrepresent the physical topology
> because the kernel doesn't handle it appropriately.

I think we are have a disagreement on what node means. Andi is saying that 
a node is bound to memory. The affinity of that chunk of memory has to be 
considered by the Kernel. If there is no memory then there is no memory 
management issue. This memory may have assigned I/O devices and cpus that 
use that memory for their operations. I think this is the working 
definition of the kernel.

You are saying a node means something that is connected to a NUMA 
interlink that may have cpus / memory / IO devices.

It seems that both definitions have been used.

> > Cpu only "nodes" would mean that all memory would be off node. Meaning 
> > whatever interconnect one has would be heavily used. Operating system and 
> > application performance will suffer.
> 
> >From this a logical step would be to change the kernel to refuse to bring
> memoryless nodes online at all.

This is the case.

Arch code typically ignores memory less nodes and assigns processors and 
I/O devices with no memory to the next node. F.e. the SGI I/O "node" only 
exists on the arch level. They are mapped to the next memory node by 
arch coide and the locality information returned to the Kernel for devices 
on that I/O node is the next memory node.

