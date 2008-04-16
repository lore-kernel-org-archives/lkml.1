Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbYDPA5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbYDPA5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYDPA5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:57:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:52111 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYDPA5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uzHfMrVv26+JYkHGcuKSlYSY12QMACJiUjZCymbhuUBlLP01r3O+OJ6bEn/Cyz1YeDH1OGqfx5gxItsYZxpqggoeZFokq1zetDDxpsoRZY6bAhVjH77HXioNs93LLXr+riaQaSfCv0yJmNMSo1IgqGOxBzIF4vQ0f1Og076TQpg=
Message-ID: <86802c440804151756w45b80052sef5c57a448d00ff1@mail.gmail.com>
Date: Tue, 15 Apr 2008 17:56:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, apw@shadowen.org,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080416004430.GA26928@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
	 <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi>
	 <20080415204025.GA29784@elte.hu>
	 <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
	 <20080416000356.GA24737@elte.hu> <20080416001816.GA26295@elte.hu>
	 <86802c440804151732j519a541t9d8e4f6b49a53313@mail.gmail.com>
	 <20080416004430.GA26928@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 5:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > >  +       unsigned long max_arch_pfn = 1ULL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);
>  > >
>  > >  and also check my analysis whether it is correct and whether it
>  > >  matches the reported bug patterns. But otherwise the fix looks like
>  > >  a safe fix for v2.6.25-final to me - it only filters out values
>  > >  from sparsemem input that are nonsensical in the sparsemem
>  > >  framework anyway.
>  >
>
> > can you check why find_max_pfn() e820_32.c need to call
>  > memory_present? wonder if it can be removed.
>
>  this is the only call to memory_present() we do in 32-bit arch setup, so
>  it's required.
>
>  (the function find_max_pfn() is woefully misnamed, but that's a cleanup
>  - i just fixed this in x86.git.)

64 bit is calling that via paging_init
==>sparse_memory_present_with_active_regions(MAX_NUMNODES).

and
void __init sparse_memory_present_with_active_regions(int nid)
{
        int i;

        for_each_active_range_index_in_nid(i, nid)
                memory_present(early_node_map[i].nid,
                                early_node_map[i].start_pfn,
                                early_node_map[i].end_pfn);
}

that is some late than 32 bit.

YH
