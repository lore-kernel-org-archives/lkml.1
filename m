Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbXDIISO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbXDIISO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 04:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXDIISN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 04:18:13 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:5183 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbXDIISK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 04:18:10 -0400
Date: Mon, 9 Apr 2007 12:25:54 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: /proc/*/pagemap BUG: sleeping function called from invalid context
Message-ID: <20070409082554.GB6532@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After
	cat /proc/self/pagemap

BUG: sleeping function called from invalid context at include/asm/uaccess.h:453
in_atomic():1, irqs_disabled():0
1 lock held by cat/14183:
 #0:  (&mm->mmap_sem){----}, at: [<c017d17b>] pagemap_read+0x11f/0x21b
 [<c01b7bc7>] copy_to_user+0x37/0x4c
 [<c017cf92>] add_to_pagemap+0x49/0x6f
 [<c017d034>] pagemap_pte_range+0x56/0x7e
 [<c017cfde>] pagemap_pte_range+0x0/0x7e
 [<c01b481d>] walk_page_range+0xf1/0x1a0
 [<c017d1e3>] pagemap_read+0x187/0x21b
 [<c01fdafa>] tty_write+0x1bb/0x1cc
 [<c017d05c>] pagemap_read+0x0/0x21b
 [<c01589b0>] vfs_read+0x72/0x95
 [<c0158cce>] sys_read+0x41/0x67
 [<c0103d96>] sysenter_past_esp+0x8f/0x99
 [<c0103d66>] sysenter_past_esp+0x5f/0x99
 =======================

