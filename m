Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYCQPDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYCQPDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYCQPDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:03:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58107 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbYCQPDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:03:38 -0400
Subject: Re: [PATCH] [0/18] GB pages hugetlb support
From: Adam Litke <agl@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <20080317258.659191058@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
Content-Type: text/plain
Organization: IBM
Date: Mon, 17 Mar 2008 10:05:07 -0500
Message-Id: <1205766307.10849.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-17 at 02:58 +0100, Andi Kleen wrote:
<snip>
> - lockdep sometimes complains about recursive page_table_locks
> for shared hugetlb memory, but as far as I can see I didn't
> actually change this area. Looks a little dubious, might
> be a false positive too.

I bet copy_hugetlb_page_range() is causing your complaints.  It takes
the dest_mm->page_table_lock followed by src_mm->page_table_lock inside
a loop and hasn't yet been converted to call spin_lock_nested().  A
harmless false positive.

> - hugemmap04 from LTP fails. Cause unknown currently

I am not sure how well LTP is tracking mainline development in this
area.  How do these patches do with the libhugetlbfs test suite?  We are
adding support for ginormous pages (1GB, 16GB, etc) but it is not
complete.  Should run fine with 2M pages though.

Before you ask, here is the link:
http://libhugetlbfs.ozlabs.org/snapshots/libhugetlbfs-dev-20080310.tar.gz

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

