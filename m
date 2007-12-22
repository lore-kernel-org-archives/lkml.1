Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXLVBfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXLVBfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXLVBde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:33:34 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53901 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751447AbXLVBdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:33:18 -0500
Message-ID: <398287205.10334@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071222013147.897522982@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sat, 22 Dec 2007 09:31:47 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] mmap read-around and readahead take 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew,

Here are the mmap read-around related patches initiated by Linus.
They are for linux-2.6.24-rc5-mm1. They're mainly about code cleanups.
The only major new feature - auto detection and early readahead for mmap
sequential reads - shows about 2% speedup on single stream case, and should
perform much better in multiple streams case.

This take: simplified patch 2, from
         mm/filemap.c |  192 +++++++++++++++++++++++++++++++++++++++-------------------
         1 files changed, 130 insertions(+), 62 deletions(-)
to
	 mm/filemap.c |  156 +++++++++++++++++++++++++++----------------------
	 1 file changed, 89 insertions(+), 67 deletions(-)


[PATCH 1/9] readahead: simplify readahead call scheme
[PATCH 2/9] readahead: clean up and simplify the code for filemap page fault readahead
[PATCH 3/9] readahead: auto detection of sequential mmap reads
[PATCH 4/9] readahead: quick startup on sequential mmap readahead
[PATCH 5/9] readahead: make ra_submit() non-static
[PATCH 6/9] readahead: save mmap read-around states in file_ra_state
[PATCH 7/9] readahead: remove unused do_page_cache_readahead()
[PATCH 8/9] readahead: move max_sane_readahead() calls into force_page_cache_readahead()
[PATCH 9/9] readahead: call max_sane_readahead() in ondemand_readahead()

Thank you,
Fengguang
-- 
