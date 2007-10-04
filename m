Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbXJDJvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbXJDJvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbXJDJvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:51:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52692 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754500AbXJDJvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:51:02 -0400
Date: Thu, 4 Oct 2007 11:49:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Subject: vm.txt: document min_free_pages as critical for correctness
Message-ID: <20071004094920.GA407@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


min_free_pages is critical for correctness, document it as such.

Signed-off-by: Pavel Machek <pavel@suse.cz>

index a0ccc5b..e460c19 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -111,6 +111,12 @@ of kilobytes free.  The VM uses this num
 value for each lowmem zone in the system.  Each lowmem zone gets 
 a number of reserved free pages based proportionally on its size.
 
+Some minimal ammount of memory is needed to satisfy PF_MEMALLOC
+allocations; if you set this to lower than 1024KB, your system will
+become subtly broken, and prone to deadlock under high loads.
+
+Setting this too high will OOM your machine instantly.
+
 ==============================================================
 
 percpu_pagelist_fraction


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
