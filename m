Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYEWS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYEWS66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYEWS6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:58:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbYEWS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:58:48 -0400
Date: Fri, 23 May 2008 11:57:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0 of 4] mm+paravirt+xen: add pte read-modify-write
 abstraction
In-Reply-To: <patchbomb.1211552448@localhost>
Message-ID: <alpine.LFD.1.10.0805231133130.3081@woody.linux-foundation.org>
References: <patchbomb.1211552448@localhost>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 23 May 2008, Jeremy Fitzhardinge wrote:
> 
> This series adds the pte_rmw_start() and pte_rmw_commit() operations,
> which change this sequence to:
> 
> 	ptent = pte_rmw_start(mm, addr, pte);
> 	ptent = pte_modify(ptent, newprot);
> 	/* ... */
> 	pte_rmw_commit(mm, addr, pte, ptent);

Can you please rename these.

It's not a general "read-modify-write" operation on the PTE, and this 
*only* works for changing protection details. In particular, you cannot 
use pte_rmw_start/commit to change the actual page. So it's very much 
about just protection bits.

It should probably also be called ptep_xyz(), since it takes a pte 
pointer, not a pte.

So maybe calling it "ptent = ptep_modify_prot_start(..)" ... 
"ptep_modify_prot_commit(..)" or something.

			Linus
