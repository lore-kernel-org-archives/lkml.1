Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZJPQ4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZJPQ4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 12:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbZJPQ4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 12:56:45 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:34030 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750751AbZJPQ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 12:56:44 -0400
Date: Fri, 16 Oct 2009 12:48:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: gerald.schaefer@de.ibm.com
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
       Robert Jennings <rcj@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Ingo Molnar <mingo@elte.hu>, Badari Pulavarty <pbadari@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/2][v2] powerpc: Make the CMM memory hotplug aware
In-Reply-To: <4AD7681C.7060800@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0910161246010.6120@gentwo.org>
References: <20091002184458.GC4908@austin.ibm.com> <20091002185248.GD4908@austin.ibm.com> <4ACDD71D.30809@linux.vnet.ibm.com> <20091008131355.GA22118@austin.ibm.com> <4AD7681C.7060800@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Gerald Schaefer wrote:

> > The pages allocated as __GFP_MOVABLE are used to store the list of pages
> > allocated by the balloon.  They reference virtual addresses and it would
> > be fine for the kernel to migrate the physical pages for those, the
> > balloon would not notice this.
>
> Does page migration really work for kernel pages that were allocated
> with __get_free_page()? I was wondering if we can do this on s390, where
> we have a 1:1 mapping of kernel virtual to physical addresses, but
> looking at migrate_pages() and friends, it seems that kernel pages
> w/o mapping and rmap should not be migrateable at all. Any thoughts from
> the memory migration experts?

page migration only works for pages where we have some way of accounting
for all the references to a page. This usually mean using reverse mappings
(anon list, radix trees and page tables).


