Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYBTOw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYBTOw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYBTOwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:52:46 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37744 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYBTOwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:52:45 -0500
Subject: Re: [PATCH] hugetlb: ensure we do not reference a surplus page
	after handing it to buddy
From: Adam Litke <agl@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Nishanth Aravamudan <nacc@us.ibm.com>,
       William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080219153037.ec336fd2.akpm@linux-foundation.org>
References: <1203445688.0@pinky>
	 <1203446512.11987.36.camel@localhost.localdomain>
	 <20080219153037.ec336fd2.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM
Date: Wed, 20 Feb 2008 08:59:34 -0600
Message-Id: <1203519574.11987.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-19 at 15:30 -0800, Andrew Morton wrote:
> On Tue, 19 Feb 2008 12:41:51 -0600 Adam Litke <agl@us.ibm.com> wrote:
> 
> > Indeed.  I'll take credit for this thinko...
> > 
> > On Tue, 2008-02-19 at 18:28 +0000, Andy Whitcroft wrote:
> > > When we free a page via free_huge_page and we detect that we are in
> > > surplus the page will be returned to the buddy.  After this we no longer
> > > own the page.  However at the end free_huge_page we clear out our mapping
> > > pointer from page private.  Even where the page is not a surplus we
> > > free the page to the hugepage pool, drop the pool locks and then clear
> > > page private.  In either case the page may have been reallocated.  BAD.
> > > 
> > > Make sure we clear out page private before we free the page.
> > > 
> > > Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> > 
> > Acked-by: Adam Litke <agl@us.ibm.com>
> 
> Was I right to assume that this is also needed in 2.6.24.x?

Yep.  Thanks Andrew.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

