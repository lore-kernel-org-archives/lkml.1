Return-Path: <linux-kernel-owner+w=401wt.eu-S1762544AbYFGRiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762544AbYFGRiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 13:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYFGRin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 13:38:43 -0400
Received: from gw.goop.org ([64.81.55.164]:60991 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbYFGRin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 13:38:43 -0400
Message-ID: <484AC779.1070803@goop.org>
Date: Sat, 07 Jun 2008 18:38:01 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] mm: vmap rewrite
References: <20080605102015.GA11366@wotan.suse.de>
In-Reply-To: <20080605102015.GA11366@wotan.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Hi. RFC.
>
> Rewrite the vmap allocator to use rbtrees and lazy tlb flushing, and provide a
> fast, scalable percpu frontend for small vmaps.
>
> XEN and PAT and such do not like deferred TLB flushing. They just need to call
> vm_unmap_aliases() in order to flush any deferred mappings.  That call is very
> expensive (well, actually not a lot more expensive than a single vunmap under
> the old scheme), however it should be OK if not called too often.
>   

What are the performance characteristics?  Can it be fast-pathed if 
there are no outstanding aliases?

For Xen, I'd need to do the alias unmap each time it allocates a page 
for use in a pagetable.  For initial process construction that could be 
deferred, but creating mappings on a live process could get fairly 
expensive as a result.  The ideal interface for me would be a way of 
testing if a given page has vmap aliases, so that we need only do the 
unmap if really necessary.  I'm guessing that goes into "need a new page 
flag" territory though...

    J
