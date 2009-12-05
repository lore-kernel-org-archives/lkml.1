Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZLEMhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZLEMhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 07:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZLEMhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 07:37:07 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:19334 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388AbZLEMhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 07:37:06 -0500
X-Trace: 301916291/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoAADLjGUtQKW/F/2dsb2JhbAAI1QuEMwQ
X-IronPort-AV: E=Sophos;i="4.47,346,1257120000"; 
   d="scan'208";a="301916291"
Date: Sat, 5 Dec 2009 12:37:00 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: Acquire the i_mmap_lock before walking the
 prio_tree to unmap a page
In-Reply-To: <20091202221947.GB26702@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0912051235001.31181@sister.anvils>
References: <20091202141930.GF1457@csn.ul.ie> <Pine.LNX.4.64.0912022003100.8113@sister.anvils>
 <20091202221602.GA26702@csn.ul.ie> <20091202221947.GB26702@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009, Mel Gorman wrote:
> On Wed, Dec 02, 2009 at 10:16:02PM +0000, Mel Gorman wrote:
> > On Wed, Dec 02, 2009 at 08:13:39PM +0000, Hugh Dickins wrote:
> > > 
> > > But the comment seems wrong to me: hugetlb_instantiation_mutex
> > > guards against concurrent hugetlb_fault()s; but the structure of
> > > the prio_tree shifts as vmas based on that inode are inserted into
> > > (mmap'ed) and removed from (munmap'ed) that tree (always while
> > > holding i_mmap_lock).  I don't see hugetlb_instantiation_mutex
> > > giving us any protection against this at present.
> > > 
> > 
> > You're right of course. I'll report without that nonsense included.
> > 
> 
> Actually, shouldn't the mmap_sem be protecting against concurrent mmap and
> munmap altering the tree? The comment is still bogus of course.

No, the mmap_sem can only protect against other threads sharing that
same mm: whereas the prio_tree can shift around according to concurrent
mmaps and munmaps of the same file in other mms.

Hugh
