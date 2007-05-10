Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbXEJUbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbXEJUbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXEJUbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:31:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57326 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755016AbXEJUbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:31:24 -0400
Date: Thu, 10 May 2007 13:31:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: slub-i386-support.patch
In-Reply-To: <20070510131724.150e1e99.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705101328110.11759@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
 <20070510131724.150e1e99.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Andrew Morton wrote:

> > Though when I look at the patchset (copied below), I do wonder why
> > it puts a quicklist_trim() into i386's cpu_idle() and flush_tlb_mm():
> > neither is where I'd expect us to be secretly freeing pages.  Ah,
> > several arches do it in cpu_idle(): how odd, oh well.
> 
> Christoph, could you please check that this is justified?

This has been that way for years for ia64 and sparc64. quicklist page 
freeing needs to be synced with the tlb flushing since page table pages 
may be flushed with the pages gathered in the tlb_mm struct. Dave Miller 
set this up initially as far as I can tell. He could probably give more 
details on why this was done historically.

ccing Dave.

