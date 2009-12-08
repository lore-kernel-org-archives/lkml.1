Return-Path: <linux-kernel-owner+w=401wt.eu-S966783AbZLHWf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966783AbZLHWf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966598AbZLHWfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:35:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966578AbZLHWfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:35:50 -0500
Date: Tue, 8 Dec 2009 14:35:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: n-horiguchi@ah.jp.nec.com
Cc: LKML <linux-kernel@vger.kernel.org>, hugh.dickins@tiscali.co.uk,
       linux-mm <linux-mm@kvack.org>, stable@kernel.org
Subject: Re: [PATCH] mm hugetlb x86: fix hugepage memory leak in mincore()
Message-Id: <20091208143506.250b47c7.akpm@linux-foundation.org>
In-Reply-To: <4B1CB5D2.7020403@ah.jp.nec.com>
References: <1260172193-14397-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<4B1CB5D2.7020403@ah.jp.nec.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Dec 2009 16:59:14 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Most callers of pmd_none_or_clear_bad() check whether the target
> page is in a hugepage or not, but mincore() and walk_page_range()
> do not check it. So if we use mincore() on a hugepage on x86 machine,
> the hugepage memory is leaked as shown below.
> This patch fixes it by extending mincore() system call to support hugepages.

This bug is fairly embarrassing.  I tagged the patch for a -stable
backport.

