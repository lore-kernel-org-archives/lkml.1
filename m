Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbYEHB63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbYEHB63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbYEHB6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:58:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755962AbYEHB6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:58:16 -0400
Date: Wed, 7 May 2008 18:57:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <20080508015249.GT8276@duo.random>
Message-ID: <alpine.LFD.1.10.0805071853500.3024@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080507222205.GC8276@duo.random> <20080507153103.237ea5b6.akpm@linux-foundation.org> <20080507224406.GI8276@duo.random> <20080507155914.d7790069.akpm@linux-foundation.org>
 <alpine.LFD.1.10.0805071610490.3024@woody.linux-foundation.org> <Pine.LNX.4.64.0805071637360.14337@schroedinger.engr.sgi.com> <alpine.LFD.1.10.0805071655100.3024@woody.linux-foundation.org> <Pine.LNX.4.64.0805071752490.14829@schroedinger.engr.sgi.com>
 <alpine.LFD.1.10.0805071833450.3024@woody.linux-foundation.org> <20080508015249.GT8276@duo.random>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Andrea Arcangeli wrote:
> 
> So because the bitflag can't prevent taking the same lock twice on two
> different vmas in the same mm, we still can't remove the sorting

Andrea. 

Take five minutes. Take a deep breadth. And *think* about actually reading 
what I wrote.

The bitflag *can* prevent taking the same lock twice. It just needs to be 
in the right place.

Let me quote it for you:

> So the flag wouldn't be one of the VM_xyzzy flags, and would require 
> adding a new field to "struct anon_vma()"

IOW, just make it be in that anon_vma (and the address_space). No sorting 
required.

> I think it's more interesting to put a cap on the number of vmas to
> min(1024,max_map_count). The sort time on an 8k array runs in constant
> time.

Shut up already. It's not constant time just because you can cap the 
overhead. We're not in a university, and we care about performance, not 
your made-up big-O notation.

			Linus
