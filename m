Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbXBDKuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbXBDKuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 05:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXBDKuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 05:50:17 -0500
Received: from mail.suse.de ([195.135.220.2]:56511 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbXBDKuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 05:50:16 -0500
Date: Sun, 4 Feb 2007 11:50:15 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 9/9] mm: fix pagecache write deadlocks
Message-ID: <20070204105015.GB29943@wotan.suse.de>
References: <20070204063707.23659.20741.sendpatchset@linux.site> <20070204063833.23659.55105.sendpatchset@linux.site> <20070204014445.88e6c8c7.akpm@linux-foundation.org> <20070204101529.GA22004@wotan.suse.de> <20070204023055.2583fd65.akpm@linux-foundation.org> <20070204104609.GA29943@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070204104609.GA29943@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 11:46:09AM +0100, Nick Piggin wrote:
> 
> > It's better than taking mmap_sem and walking pagetables...
> 
> I'm not convinced.

Though I am more convinced that looking at mm *at all* (either to
take the mmap_sem and find the vma, or to take the mmap_sem and
run get_user_pages) is going to hurt.

We'd have to special case kernel threads, which don't even have an
mm, let alone the vmas... too ugly.

I'll revert to my temporary-page approach: at least that will
fix the problem.

