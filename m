Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYJHQTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYJHQTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 12:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYJHQS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 12:18:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbYJHQS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 12:18:58 -0400
Message-ID: <48ECDD37.8050506@linux-foundation.org>
Date: Wed, 08 Oct 2008 11:17:59 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/1] hugetlbfs: handle pages higher order than MAX_ORDER
References: <1223458431-12640-1-git-send-email-apw@shadowen.org> <1223458431-12640-2-git-send-email-apw@shadowen.org>
In-Reply-To: <1223458431-12640-2-git-send-email-apw@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> When working with hugepages, hugetlbfs assumes that those hugepages
> are smaller than MAX_ORDER.  Specifically it assumes that the mem_map
> is contigious and uses that to optimise access to the elements of the
> mem_map that represent the hugepage.  Gigantic pages (such as 16GB pages
> on powerpc) by definition are of greater order than MAX_ORDER (larger
> than MAX_ORDER_NR_PAGES in size).  This means that we can no longer make
> use of the buddy alloctor guarentees for the contiguity of the mem_map,
> which ensures that the mem_map is at least contigious for maximmally
> aligned areas of MAX_ORDER_NR_PAGES pages.

But the memmap is contiguous in most cases. FLATMEM, VMEMMAP etc. Its only
some special sparsemem configurations that couldhave the issue because they
break up the vmemmap. x86_64 uses VMEMMAP by default. Is this for i386?

