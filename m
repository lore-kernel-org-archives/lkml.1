Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYLKKIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYLKKIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 05:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYLKKIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 05:08:10 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47627 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361AbYLKKIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 05:08:09 -0500
Subject: Re: [PATCH 07/15] kmemleak: Add memleak_alloc callback from
	alloc_large_system_hash
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1228989052.332.12.camel@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182732.30323.39834.stgit@pc1117.cambridge.arm.com>
	 <1228935860.9737.98.camel@nimitz>
	 <1228989052.332.12.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 11 Dec 2008 10:08:06 +0000
Message-Id: <1228990086.332.15.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Dec 2008 10:08:07.0093 (UTC) FILETIME=[5CFB0E50:01C95B78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-11 at 09:50 +0000, Catalin Marinas wrote:
> On Wed, 2008-12-10 at 11:04 -0800, Dave Hansen wrote:
> > On Wed, 2008-12-10 at 18:27 +0000, Catalin Marinas wrote:
> > > 
> > > @@ -4570,6 +4571,8 @@ void *__init alloc_large_system_hash(const char *tablename,
> > >         if (_hash_mask)
> > >                 *_hash_mask = (1 << log2qty) - 1;
> > >  
> > > +       memleak_alloc(table, size, 1, GFP_ATOMIC);
> > > +
> > >         return table;
> > >  }
> > 
> > Why is this sucker GFP_ATOMIC?
> 
> It could be GFP_KERNEL, it don't think it really matter at this point.

Actually, for consistency is should be GFP_ATOMIC even if the flag might
not be used. All the other allocations in this function (vmalloc,
__get_free_pages) use GFP_ATOMIC.

-- 
Catalin

