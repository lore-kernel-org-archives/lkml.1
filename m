Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYCEVGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYCEVGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYCEVGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:06:41 -0500
Received: from relay1.sgi.com ([192.48.171.29]:58961 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753791AbYCEVGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:06:41 -0500
Date: Wed, 5 Mar 2008 13:06:30 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: npiggin@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yanmin_zhang@linux.intel.com, dada1@cosmosbay.com
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <20080304.161003.129716254.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0803051257030.30742@schroedinger.engr.sgi.com>
References: <20080303201701.GF8974@wotan.suse.de>
 <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
 <20080305000637.GA1510@wotan.suse.de> <20080304.161003.129716254.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, David Miller wrote:

> > Huh?? It is not a new definition, it is exactly what SLAB does. And
> > then you go and do something different and claim that you follow
> > what slab does.
> 
> I completely agree with Nick.

So you also want subalignment because of cacheline crossing for 24 byte 
slabs? We then only have 2 objects per cacheline instead of 3 but no 
crossing anymore.

Well okay if there are multiple requests then lets merge Nick's patch that 
does this. Still think that this will do much ...
Instead of 170 we will only have 128 objects per slab (64 byte 
cacheline).

It will affect the following slab caches (mm) reducing the density of 
objects. 

scsi_bidi_sdb numa_policy fasync_cache xfs_bmap_free_item xfs_dabuf 
fstrm_item dm_target_io

Nothing related to networking....
