Return-Path: <linux-kernel-owner+w=401wt.eu-S1764896AbXHVSpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764896AbXHVSpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761917AbXHVSpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:45:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:59592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760275AbXHVSpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:45:07 -0400
Date: Wed, 22 Aug 2007 21:38:58 +0200
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1
Message-ID: <20070822193857.GC8058@bingen.suse.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822110348.8fd6a937.randy.dunlap@oracle.com> <20070822113211.9ac85162.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822113211.9ac85162.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:32:11AM -0700, Andrew Morton wrote:
> > On Wed, 22 Aug 2007 02:06:48 -0700 Andrew Morton wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> > 
> > allyesconfig on x86_64 says:
> > 
> > kernel/unwind.c:1016:31: error: undefined identifier '__builtin_labs'
> > kernel/unwind.c:1232:25: error: undefined identifier '__builtin_labs'
> > 
> 

Why does that compiler not know __builtin_abs?

> One wonders why x86_64-mm-unwinder.patch has an open-coded call to
> __builtin_labs(), when include/linux/kernel.h:abs() should do a fine job.

I'll fix.

> 
> And what's this stuff, anyway?
> 
> +typedef unsigned long uleb128_t;
> +typedef   signed long sleb128_t;
> +#define sleb128abs __builtin_labs
> 
> unsigned and signed little-endian 128-bit types?  Nope, they're 32-bit or
> 64-bit.   All very mysterious.

dwarf2 uses a magic compressing encoding for numbers that uses less bytes
for small numbers and more bytes for larger numbers. These are the base
types for this.

It's similar to fs/reiser4/dscale.h in your tree.

-Andi

