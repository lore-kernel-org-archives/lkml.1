Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbZLHWjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbZLHWjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbZLHWja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:39:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756368AbZLHWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:39:29 -0500
Date: Tue, 8 Dec 2009 14:39:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: n-horiguchi@ah.jp.nec.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       hugh.dickins@tiscali.co.uk, ak@linux.intel.com,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/2] mm hugetlb x86: add hugepage support to pagemap
Message-Id: <20091208143928.f3aa0ad2.akpm@linux-foundation.org>
In-Reply-To: <4B1CB5D6.9080007@ah.jp.nec.com>
References: <4B1CB5D6.9080007@ah.jp.nec.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Dec 2009 16:59:18 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Most callers of pmd_none_or_clear_bad() check whether the target
> page is in a hugepage or not, but mincore() and walk_page_range() do
> not check it. So if we read /proc/pid/pagemap for the hugepage
> on x86 machine, the hugepage memory is leaked as shown below.
> This patch fixes it by extending pagemap interface to support hugepages.
> 
> I split this fix into two patches.  The first patch just adds the check
> for hugepages, and the second patch adds a new member to struct mm_walk
> to handle the hugepages.

I kind of dislike the practice of putting all the changelog in patch
[0/n] and then leaving the patches themselves practically
unchangelogged.  Because

a) Someone (ie: me) needs to go and shuffle all the text around so
   that the information gets itself into the git record.  We don't add
   changelog-only commits to git!

b) Someone (ie: me) might decide to backport a subset of the patches
   into -stable.  Now someone (ie: me) needs to carve up the changelogs
   so that the pieces which go into -stable still make standalone sense.

I'm not sure that I did this particularly well in this case.  Oh well.


Please confirm that
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch is
suitable for a -stable backport without inclusion of
mm-hugetlb-add-hugepage-support-to-pagemap.patch.  I think it is.

