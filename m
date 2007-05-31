Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbXEaXOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbXEaXOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbXEaXOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:14:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33146 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbXEaXOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:14:09 -0400
Date: Thu, 31 May 2007 16:13:54 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-ID: <20070531231354.GR20632@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 11:58:23PM -0700, Andrew Morton wrote:
>  git-ocfs2.patch

Andrew, thanks for getting that back in there.


mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch broke ocfs2 shared
writable mmap. We hang on a page lock because ->page_mkwrite() is
being called with the page already locked:

+	/*
+	 * For consistency in subsequent calls, make the nopage_page always
+	 * locked.
+	 */
+	if (unlikely(!(vma->vm_flags & VM_CAN_INVALIDATE)))
+		lock_page(nopage_page);

It wasn't previously being called with the page lock held, intentionally.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
