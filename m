Return-Path: <linux-kernel-owner+w=401wt.eu-S1161151AbXBGKlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbXBGKlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161164AbXBGKlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:41:31 -0500
Received: from mail.suse.de ([195.135.220.2]:57964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161151AbXBGKla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:41:30 -0500
From: Andi Kleen <ak@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with memory-less-node
Date: Wed, 7 Feb 2007 11:41:25 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, clameter@engr.sgi.com,
       akpm@osdl.org
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com> <200702071119.03125.ak@suse.de> <20070207193749.fa58632e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070207193749.fa58632e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702071141.25990.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 February 2007 11:37, KAMEZAWA Hiroyuki wrote:
> On Wed, 7 Feb 2007 11:19:02 +0100
> Andi Kleen <ak@suse.de> wrote:
> 
> > 
> > > AFAIK, ia64 creates nodes just depends on SRAT's possible resource information.
> > > Then, ia64 can create cpu-memory-less-node(node with no available resource.).
> > > (*)I don't like this.
> > > 
> > > If we don't allow memory-less-node, we may have to add several codes for cpu-hot-add.
> > > cpus should be moved to nearby node at hotadd .
> > > And node-hot-add have to care that cpus mustn't be added before memory, cpu-driven 
> > > node-hot-add will never occur. (ACPI's 'container' device spec can't guaranntee this.)
> > 
> > You can also alias node numbers to solve this: just point multiple node numbers 
> > to the same pgdat. For a memory less node this would be a nearby one.
> > 
> Hmm, interesting...the 'alias' means follwing ?

Yes.

> NODE_DATA(A) = pgdat_for_A
> NODE_DATA(B) = pgdat_for_A // B is memory-less.
> - NODE_DATA(B) is valid but B is not online.

Well it is online because A is. For all practical purposes
it is A, just under a different name.

> ==
> looks complicated..and we have to care /sys/devices/system/node handling.

x86-64 used to do that when it still only did 1:1 cpu<->memory mappings.
I don't remember any problems with it.

-Andi

