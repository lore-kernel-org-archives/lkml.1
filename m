Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYCNKnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYCNKnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 06:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYCNKnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 06:43:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:26922 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYCNKnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 06:43:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=XG6zTUG9P0Ph9PlGdez0ANIUXMy6o9VBpG52kp/oeJM8qE6N3oT1qYf2p2gNUrHnZWRv8Gk8Ee+6WZII5Sz3dxf44wvAwioLOhx6kB8NtamShlwKJIEX0K882U0s7oWHM6K5MBHQo/nZtBvH95MSfgWkw75V79fSesxTwRWmmdc=
Date: Fri, 14 Mar 2008 18:49:06 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, akpm@linux-foundation.org, jack@suse.cz,
       chris@linuxinfotag.de
Subject: [PATCH][BUG 10227] readahead ret value fix
Message-ID: <20080314104906.GA2898@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the page_offset > end_index, the return value should be updated to 0,
avoiding the redundant read_pages

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
mm/readahead.c |    4 +++-
1 file changed, 3 insertions(+), 1 deletion(-)

diff -upr linux/mm/readahead.c linux.new/mm/readahead.c
--- linux/mm/readahead.c	2008-03-14 18:38:12.000000000 +0800
+++ linux.new/mm/readahead.c	2008-03-14 18:38:58.000000000 +0800
@@ -144,8 +144,10 @@ __do_page_cache_readahead(struct address
 	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
 		pgoff_t page_offset = offset + page_idx;
 
-		if (page_offset > end_index)
+		if (page_offset > end_index) {
+			ret = 0;
 			break;
+		}
 
 		rcu_read_lock();
 		page = radix_tree_lookup(&mapping->page_tree, page_offset);
