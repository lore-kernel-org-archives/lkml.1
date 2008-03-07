Return-Path: <linux-kernel-owner+w=401wt.eu-S1762212AbYCGFMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212AbYCGFMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYCGFL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:11:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40716 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbYCGFL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:11:57 -0500
Date: Thu, 6 Mar 2008 21:11:39 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 2/3] slab: introduce SMP alignment
In-Reply-To: <20080307043700.GI21185@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803062108210.1143@schroedinger.engr.sgi.com>
References: <20080303093449.GA15091@wotan.suse.de> <20080303093529.GB15091@wotan.suse.de>
 <Pine.LNX.4.64.0803031104570.6917@schroedinger.engr.sgi.com>
 <20080303200355.GB8974@wotan.suse.de> <Pine.LNX.4.64.0803031208400.16049@schroedinger.engr.sgi.com>
 <20080303201211.GE8974@wotan.suse.de> <Pine.LNX.4.64.0803031216430.3110@schroedinger.engr.sgi.com>
 <20080303202411.GH8974@wotan.suse.de> <Pine.LNX.4.64.0803031327330.4375@schroedinger.engr.sgi.com>
 <20080307043700.GI21185@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Nick Piggin wrote:

> > No the slab allocators were optimized for VSMP so that the 
> > internode_alignment is not necessary there. That was actually one of the 
> > requirements that triggered the slab numa work.
> 
> BTW. can you explain this incredible claim that the slab allocators
> do not need internode_alignment to avoid false sharing of allocated
> objects on VSMP? I don't understand how that would work at all.

The queues are per node which means that pages from which we allocate are 
distinct per node. As long as processes allocate and free object on a 
single node all is fine. Problems can arise though if objects are used 
across node. The earlier incarnation of SLAB had a single global queue for 
slab pages and objects could be allocated from an arbitrary processor. 
Objects from the same page were allocated from all processors.

