Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbYHOOa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbYHOOa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYHOOaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:30:20 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59669 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYHOOaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:30:19 -0400
Date: Fri, 15 Aug 2008 15:30:14 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix /proc/meminfo DirectMap
In-Reply-To: <20080815132854.GG30597@elte.hu>
Message-ID: <Pine.LNX.4.64.0808151513400.6593@blonde.site>
References: <Pine.LNX.4.64.0808151351220.28840@blonde.site>
 <20080815132854.GG30597@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Ingo Molnar wrote:
> * Hugh Dickins <hugh@veritas.com> wrote:
> 
> > Should we really be using level2_ident_pgt (which needs to avoid NX) 
> > for the final direct map (which wants to use NX)?  But my attempt to 
> > build up a fresh pagetable there failed miserably to boot!
> 
> hm, exactly what change have you tried? (patch?)

As soon as that kernel failed to boot, I chucked the patch away and
erased it from my mind: much better to leave such a change to the
people who are intimate with this sequence and can debug it.

It wasn't anything much, the page to use has already been set aside
for alloc_low_page, I thought it was just a matter of breaking the
association with level2_ident_pgt at the right level then letting
phys_pmd_init do its usual setup from scratch.

Maybe it didn't work because I got it slightly wrong, or maybe it
it didn't work for more subtle reasons e.g. I was then building up
the first 1GB of direct map 2MB by 2MB: if direct map is actually
used in there and falls out of TLB, I'd certainly be in trouble.

Hugh
