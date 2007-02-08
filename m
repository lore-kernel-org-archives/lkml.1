Return-Path: <linux-kernel-owner+w=401wt.eu-S1423253AbXBHT0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423253AbXBHT0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423259AbXBHT0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:26:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34837 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423253AbXBHT0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:26:37 -0500
Date: Thu, 8 Feb 2007 11:26:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, GOTO <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070208112629.3a4ce158.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702081106460.11045@schroedinger.engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<p73ejp2mfqh.fsf@bingen.suse.de>
	<20070207082330.d07525ec.akpm@linux-foundation.org>
	<200702071750.55283.ak@suse.de>
	<20070207094344.0efdde10.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702081106460.11045@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 11:09:40 -0800 (PST) Christoph Lameter <clameter@sgi.com> wrote:

> > > > and to 
> > > > accurately present the machine's topology to the user without us having to
> > > > go adding falsehoods like this?
> > > 
> > > a node is a piece of memory. Without memory it doesn't make sense.
> > 
> > Who said?  I can pick up a piece of circuitry which has four CPUs and no
> > RAM, wave it about then stick it in a computer.  The kernel is just wrong,
> > surely?
> 
> Surely your computer has some memory so attach it to that memory (which 
> in a NUMA system would be one or the other node).

"attach it".  But it _isn't_ attached.  There is no memory on this node. 
We seem to be saying that we should misrepresent the physical topology
because the kernel doesn't handle it appropriately.

> Cpu only "nodes" would mean that all memory would be off node. Meaning 
> whatever interconnect one has would be heavily used. Operating system and 
> application performance will suffer.

>From this a logical step would be to change the kernel to refuse to bring
memoryless nodes online at all.

If that's not an approproate solution, then there must be a legtimate
reason for using memoryless nodes.  

Which is it?
