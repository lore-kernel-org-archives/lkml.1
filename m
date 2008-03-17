Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYCQPa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYCQPa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYCQPau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:30:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57452 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYCQPat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:30:49 -0400
Date: Mon, 17 Mar 2008 16:33:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Adam Litke <agl@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [0/18] GB pages hugetlb support
Message-ID: <20080317153314.GD5578@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <1205766307.10849.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205766307.10849.38.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I bet copy_hugetlb_page_range() is causing your complaints.  It takes
> the dest_mm->page_table_lock followed by src_mm->page_table_lock inside
> a loop and hasn't yet been converted to call spin_lock_nested().  A
> harmless false positive.

Yes. Looking at the warning I'm not sure why lockdep doesn't filter
it out automatically. I cannot think of a legitimate case where
a "possible recursive lock" with different lock addresses would be 
a genuine bug.

So instead of a false positive, it's more like a "always false" :)

> 
> > - hugemmap04 from LTP fails. Cause unknown currently
> 
> I am not sure how well LTP is tracking mainline development in this
> area.  How do these patches do with the libhugetlbfs test suite?  We are

I wasn't aware of that one.

-Andi
