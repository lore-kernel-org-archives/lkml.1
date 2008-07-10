Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbYGJTCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbYGJTCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbYGJTB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:01:58 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58867 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbYGJTB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:01:56 -0400
Subject: Re: [PATCH 1/2] [PATCH] Fix a hugepage reservation check for
	MAP_SHARED
From: Adam Litke <agl@us.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
In-Reply-To: <20080710173021.16433.90661.sendpatchset@skynet.skynet.ie>
References: <20080710173001.16433.87538.sendpatchset@skynet.skynet.ie>
	 <20080710173021.16433.90661.sendpatchset@skynet.skynet.ie>
Content-Type: text/plain
Organization: IBM
Date: Thu, 10 Jul 2008 14:01:59 -0500
Message-Id: <1215716519.14825.112.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 18:30 +0100, Mel Gorman wrote:
> When removing a huge page from the hugepage pool for a fault the system
> checks to see if the mapping requires additional pages to be reserved, and
> if it does whether there are any unreserved pages remaining.  If not, the
> allocation fails without even attempting to get a page. In order to determine
> whether to apply this check we call vma_has_private_reserves() which tells us
> if this vma is MAP_PRIVATE and is the owner.  This incorrectly triggers the
> remaining reservation test for MAP_SHARED mappings which prevents allocation
> of the final page in the pool even though it is reserved for this mapping.
> 
> In reality we only want to check this for MAP_PRIVATE mappings where the
> process is not the original mapper.  Replace vma_has_private_reserves() with
> vma_has_reserves() which indicates whether further reserves are required,
> and update the caller.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Adam Litke <agl@us.ibm.com>

Tested and confirmed.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

