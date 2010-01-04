Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372Ab0ADRVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0ADRVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414Ab0ADRV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:21:29 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:26516 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860Ab0ADRV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:21:28 -0500
X-Trace: 316934983/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvUAAEuyQUtPRRyw/2dsb2JhbAAI1RmEMAQ
X-IronPort-AV: E=Sophos;i="4.47,499,1257120000"; 
   d="scan'208";a="316934983"
Date: Mon, 4 Jan 2010 17:21:26 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Eric B Munson <ebmunson@us.ibm.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: move sys_mmap_pgoff from util.c
In-Reply-To: <20100104123858.GA5045@us.ibm.com>
Message-ID: <alpine.LSU.2.00.1001041716370.9825@sister.anvils>
References: <alpine.LSU.2.00.0912302009040.30390@sister.anvils> <20100104123858.GA5045@us.ibm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010, Eric B Munson wrote:
> On Wed, 30 Dec 2009, Hugh Dickins wrote:
> 
> > Move sys_mmap_pgoff() from mm/util.c to mm/mmap.c and mm/nommu.c,
> > where we'd expect to find such code: especially now that it contains
> > the MAP_HUGETLB handling.  Revert mm/util.c to how it was in 2.6.32.
> > 
> > This patch just ignores MAP_HUGETLB in the nommu case, as in 2.6.32,
> > whereas 2.6.33-rc2 reported -ENOSYS.  Perhaps validate_mmap_request()
> > should reject it with -EINVAL?  Add that later if necessary.
> > 
> > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> I think that -ENOSYS is the correcet response in the nommu case, but
> I that can be added in a later patch.
> 
> Acked-by: Eric B Munson <ebmunson@us.ibm.com>

Thanks.  I had believed -ENOSYS was solely for unsupported system calls,
so thought it inappropriate here; but we seem to have quite a few places
which are using it indeed for "Function not implemented", and -EINVAL is
always so very overloaded that an alternative can be a lot more helpful.
Okay, I'll send a patch to give -ENOSYS for MAP_HUGETLB on nommu, which
will be consistent with mmu.

Hugh
