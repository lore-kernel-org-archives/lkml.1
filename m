Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbYE1SPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbYE1SPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYE1SPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:15:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34743 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYE1SPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:15:41 -0400
Subject: Re: [PATCH 3/3] Guarantee that COW faults for a process that
	called mmap(MAP_PRIVATE) on hugetlbfs will succeed
From: Adam Litke <agl@us.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, dean@arctic.org, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, dwg@au1.ibm.com, apw@shadowen.org,
       linux-mm@kvack.org, andi@firstfloor.org, kenchen@google.com,
       abh@cray.com, hannes@saeurebad.de
In-Reply-To: <20080528160024.GA19349@csn.ul.ie>
References: <20080527185028.16194.57978.sendpatchset@skynet.skynet.ie>
	 <20080527185128.16194.87380.sendpatchset@skynet.skynet.ie>
	 <20080528160024.GA19349@csn.ul.ie>
Content-Type: text/plain
Organization: IBM
Date: Wed, 28 May 2008 13:15:34 -0500
Message-Id: <1211998534.12036.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-28 at 17:00 +0100, Mel Gorman wrote:
> [PATCH 4/3] Fix prio tree lookup
> 
> I spoke too soon. This is a fix to patch 3/3.
> 
> If a child unmaps the start of the VMA, the start address is different and
> that is perfectly legimite making the BUG_ON check bogus and should be removed.
> While page cache lookups are in HPAGE_SIZE, the vma->vm_pgoff is in PAGE_SIZE
> units, not HPAGE_SIZE. The offset calculation needs to be in PAGE_SIZE units
> to find other VMAs that are mapping the same range of pages. This patch
> fixes the offset calculation and adds an explanation comment as to why it
> is different from a page cache lookup.
> 
> Credit goes to Johannes Weiner for spotting the bogus BUG_ON on IRC which
> led to the discovery of the faulty offset calculation.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Adam Litke <agl@us.ibm.com>

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

