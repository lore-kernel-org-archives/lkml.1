Return-Path: <linux-kernel-owner+w=401wt.eu-S1764915AbXHVTSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764915AbXHVTSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761044AbXHVTSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:18:24 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:48261 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261AbXHVTSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:18:23 -0400
Date: Wed, 22 Aug 2007 12:17:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: 2.6.23-rc3-mm1
Message-Id: <20070822121731.011cd263.randy.dunlap@oracle.com>
In-Reply-To: <20070822193857.GC8058@bingen.suse.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<20070822110348.8fd6a937.randy.dunlap@oracle.com>
	<20070822113211.9ac85162.akpm@linux-foundation.org>
	<20070822193857.GC8058@bingen.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 21:38:58 +0200 Andi Kleen wrote:

> On Wed, Aug 22, 2007 at 11:32:11AM -0700, Andrew Morton wrote:
> > > On Wed, 22 Aug 2007 02:06:48 -0700 Andrew Morton wrote:
> > > 
> > > > 
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> > > 
> > > allyesconfig on x86_64 says:
> > > 
> > > kernel/unwind.c:1016:31: error: undefined identifier '__builtin_labs'
> > > kernel/unwind.c:1232:25: error: undefined identifier '__builtin_labs'
> > > 
> > 
> 
> Why does that compiler not know __builtin_abs?

I dunno:

> gcc --version
gcc (GCC) 4.1.0 (SUSE Linux)


> > One wonders why x86_64-mm-unwinder.patch has an open-coded call to
> > __builtin_labs(), when include/linux/kernel.h:abs() should do a fine job.
> 
> I'll fix.
> 
> > 
> > And what's this stuff, anyway?
> > 
> > +typedef unsigned long uleb128_t;
> > +typedef   signed long sleb128_t;
> > +#define sleb128abs __builtin_labs
> > 
> > unsigned and signed little-endian 128-bit types?  Nope, they're 32-bit or
> > 64-bit.   All very mysterious.
> 
> dwarf2 uses a magic compressing encoding for numbers that uses less bytes
> for small numbers and more bytes for larger numbers. These are the base
> types for this.
> 
> It's similar to fs/reiser4/dscale.h in your tree.
> 
> -Andi

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
