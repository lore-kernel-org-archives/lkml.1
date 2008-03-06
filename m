Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbYCFWxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbYCFWxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYCFWx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:53:29 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54315 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755389AbYCFWx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:53:28 -0500
Date: Thu, 6 Mar 2008 14:53:11 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <20080306024904.GA27150@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803061451230.16212@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803031107130.6917@schroedinger.engr.sgi.com>
 <20080303200613.GC8974@wotan.suse.de> <Pine.LNX.4.64.0803031209570.16049@schroedinger.engr.sgi.com>
 <20080303201701.GF8974@wotan.suse.de> <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
 <84144f020803031330i2c0ea1f6kc5b02c8b26145797@mail.gmail.com>
 <Pine.LNX.4.64.0803031331340.4375@schroedinger.engr.sgi.com>
 <47CC6F30.50802@cs.helsinki.fi> <20080305002821.GD1510@wotan.suse.de>
 <Pine.LNX.4.64.0803051254570.30742@schroedinger.engr.sgi.com>
 <20080306024904.GA27150@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Nick Piggin wrote:

> > That was due to SLUB's support for smaller allocation sizes. AFAICT has 
> > nothing to do with alignment.
> 
> The smaller sizes meant objects were less often aligned on cacheline
> boundaries.

Right since SLAB_HWCACHE_ALIGN does not align for very small objects.

> We could, but I'd rather just use the flag.

Do you have a case in mind where that would be useful? We had a 
SLAB_HWCACHE_MUST_ALIGN or so at some point but it was rarely to never 
used. Note that there is also KMEM_CACHE which picks up the alignment from 
the compiler.


