Return-Path: <linux-kernel-owner+w=401wt.eu-S1763087AbYCCVdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763087AbYCCVdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYCCVcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:32:55 -0500
Received: from relay2.sgi.com ([192.48.171.30]:60977 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751180AbYCCVcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:32:54 -0500
Date: Mon, 3 Mar 2008 13:32:54 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <84144f020803031330i2c0ea1f6kc5b02c8b26145797@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803031331340.4375@schroedinger.engr.sgi.com>
References: <20080303093449.GA15091@wotan.suse.de> 
 <Pine.LNX.4.64.0803031107130.6917@schroedinger.engr.sgi.com> 
 <20080303200613.GC8974@wotan.suse.de>  <Pine.LNX.4.64.0803031209570.16049@schroedinger.engr.sgi.com>
  <20080303201701.GF8974@wotan.suse.de>  <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
 <84144f020803031330i2c0ea1f6kc5b02c8b26145797@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Pekka Enberg wrote:

> Well, not my definition either but SLAB has guaranteed that for small
> objects in the past, so I think Nick has a point here. However, with
> all this back and forth, I've lost track why this matters. I suppose
> it causes regression on some workload?

Well the guarantee can only be exploited if you would check the cacheline 
sizes and the object size from the code that creates the slab cache. 
Basically you would have to guestimate what the slab allocator is doing.

So the guarantee is basically meaningless. If the object is larger than a 
cacheline then this will never work.

