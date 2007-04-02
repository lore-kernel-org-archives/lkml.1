Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbXDBRek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbXDBRek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXDBRek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:34:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59440 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752366AbXDBRej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:34:39 -0400
Date: Mon, 2 Apr 2007 10:34:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
In-Reply-To: <200704021914.07541.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704021032150.31053@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
 <200704021744.39880.ak@suse.de> <Pine.LNX.4.64.0704020851300.30394@schroedinger.engr.sgi.com>
 <200704021914.07541.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Andi Kleen wrote:

> > No no no. For the gazillions time: All of 1-1 mapped kernel memory on 
> > x86_64 needs a 2 MB page table entry. The virtual memmap uses the same. 
> > There are *no* additional TLBs used.
> 
> But why do you reserve an own virtual area then if you claim to not use any
> additional mappings? 

The 1-1 area using mappings for 2MB pages right? So it uses a virtual 1-1 
area. It already has a virtual mapping.

What we do for virtual memmap here is also use 2MB pages but order the 
pages a bit different so that they provide a linear memory map.

So the number of TLBs in use stays the same. There are a few additional 
higher level page table pages that are needed to provide the alternate 
view that generates the linear mapping but that is just a couple of pages.

