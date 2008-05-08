Return-Path: <linux-kernel-owner+w=401wt.eu-S1763973AbYEHAKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763973AbYEHAKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYEHAKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:10:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbYEHAKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:10:37 -0400
Date: Wed, 7 May 2008 17:03:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <andrea@qumranet.com>, steiner@sgi.com, holt@sgi.com,
       npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <Pine.LNX.4.64.0805071637360.14337@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.1.10.0805071655100.3024@woody.linux-foundation.org>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080507222205.GC8276@duo.random>
 <20080507153103.237ea5b6.akpm@linux-foundation.org> <20080507224406.GI8276@duo.random> <20080507155914.d7790069.akpm@linux-foundation.org> <alpine.LFD.1.10.0805071610490.3024@woody.linux-foundation.org>
 <Pine.LNX.4.64.0805071637360.14337@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Christoph Lameter wrote:
> 
> Multiple vmas may share the same mapping or refer to the same anonymous 
> vma. The above code will deadlock since we may take some locks multiple 
> times.

Ok, so that actually _is_ a problem. It would be easy enough to also add 
just a flag to the vma (VM_MULTILOCKED), which is still cleaner than doing 
a vmalloc and a whole sort thing, but if this is really rare, maybe Ben's 
suggestion of just using stop-machine is actually the right one just 
because it's _so_ simple.

(That said, we're not running out of vm flags yet, and if we were, we 
could just add another word. We're already wasting that space right now on 
64-bit by calling it "unsigned long").

		Linus
