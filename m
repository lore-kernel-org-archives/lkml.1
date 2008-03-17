Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbYCQP5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbYCQP5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYCQP5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:57:24 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60194 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYCQP5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:57:23 -0400
Subject: Re: [PATCH] [0/18] GB pages hugetlb support
From: Adam Litke <agl@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <20080317153314.GD5578@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
	 <1205766307.10849.38.camel@localhost.localdomain>
	 <20080317153314.GD5578@one.firstfloor.org>
Content-Type: text/plain
Organization: IBM
Date: Mon, 17 Mar 2008 10:59:06 -0500
Message-Id: <1205769546.10849.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-17 at 16:33 +0100, Andi Kleen wrote:
> > I bet copy_hugetlb_page_range() is causing your complaints.  It takes
> > the dest_mm->page_table_lock followed by src_mm->page_table_lock inside
> > a loop and hasn't yet been converted to call spin_lock_nested().  A
> > harmless false positive.
> 
> Yes. Looking at the warning I'm not sure why lockdep doesn't filter
> it out automatically. I cannot think of a legitimate case where
> a "possible recursive lock" with different lock addresses would be 
> a genuine bug.
> 
> So instead of a false positive, it's more like a "always false" :)
> 
> > 
> > > - hugemmap04 from LTP fails. Cause unknown currently
> > 
> > I am not sure how well LTP is tracking mainline development in this
> > area.  How do these patches do with the libhugetlbfs test suite?  We are
> 
> I wasn't aware of that one.

Libhugetlbfs comes with a rigorous functional test suite.  It has test
cases for specific bugs that have since been fixed.  I ran it on your
patches and got an oops around hugetlb_overcommit_handler() when running
the 'counters' test.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

