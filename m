Return-Path: <linux-kernel-owner+w=401wt.eu-S1030770AbXCGARc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030770AbXCGARc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030771AbXCGARc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:17:32 -0500
Received: from ozlabs.org ([203.10.76.45]:53016 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030770AbXCGARb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:17:31 -0500
Subject: Re: [PATCH 6/8] Allow per-cpu variables to be page-aligned
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <20070306131522.GC9031@elte.hu>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
	 <1173185827.4644.34.camel@localhost.localdomain>
	 <1173185909.4644.36.camel@localhost.localdomain>
	 <1173186021.4644.38.camel@localhost.localdomain>
	 <20070306131522.GC9031@elte.hu>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 11:16:48 +1100
Message-Id: <1173226608.4644.59.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 14:15 +0100, Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Xen wants page-aligned GDT (and PDA must not cross a page-boundary, 
> > but that doesn't happen at the moment since it's so close to start of 
> > page).  Let's allow page-alignment in general for per-cpu data.
> > 
> > Because larger alignments can use more room, we increase the max 
> > per-cpu memory to 64k rather than 32k: it's getting a little tight.
> 
> i recently needed page-aligned per-cpu data too for KVM-paravirt. Btw., 
> what's the size increase of the native kernel?

To clarify for those reading fast, this patch doesn't increase at all,
since noone uses page-alignment.  For the next patch which aligns the
gdt, it's about +12k (21k -> 33k), but then we take away the pda in the
next patch and it drops back to +8k (the pda is in the same file as the
gdt, and on my system at least it ends up getting its own 4k alignment
too).

AFAICT, we could save the wasted partial page in three ways: by trying
to link it first, if it's only a case of one file, by having a special
page-aligned percpu data section, or by having a smarter linker.

Cheers,
Rusty.


