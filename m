Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYEHAxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYEHAxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYEHAxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:53:00 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51961 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751975AbYEHAw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:52:58 -0400
Date: Wed, 7 May 2008 19:52:56 -0500
From: Robin Holt <holt@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <andrea@qumranet.com>, steiner@sgi.com, holt@sgi.com,
       npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
Message-ID: <20080508005256.GB9878@sgi.com>
References: <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080507222205.GC8276@duo.random> <20080507153103.237ea5b6.akpm@linux-foundation.org> <20080507224406.GI8276@duo.random> <20080507155914.d7790069.akpm@linux-foundation.org> <alpine.LFD.1.10.0805071610490.3024@woody.linux-foundation.org> <Pine.LNX.4.64.0805071637360.14337@schroedinger.engr.sgi.com> <alpine.LFD.1.10.0805071655100.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071655100.3024@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 05:03:30PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 7 May 2008, Christoph Lameter wrote:
> > 
> > Multiple vmas may share the same mapping or refer to the same anonymous 
> > vma. The above code will deadlock since we may take some locks multiple 
> > times.
> 
> Ok, so that actually _is_ a problem. It would be easy enough to also add 
> just a flag to the vma (VM_MULTILOCKED), which is still cleaner than doing 
> a vmalloc and a whole sort thing, but if this is really rare, maybe Ben's 
> suggestion of just using stop-machine is actually the right one just 
> because it's _so_ simple.

Also, stop-machine will not work if we come to the conclusion that
i_mmap_lock and anon_vma->lock need to be sleepable locks.

Thanks,
Robin Holt
