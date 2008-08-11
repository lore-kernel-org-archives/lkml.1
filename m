Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYHKWfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYHKWfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYHKWe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:34:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:65401 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYHKWe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:34:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QGmvB1agbfid1OIvQDRKuEgvra+eSGiTX9Tu+NxdyRZ+1pLljITD9qHntZf1sEVSHO
         bQyKADLrWGDcQFBlm+UOw34COYrcD1m9ZFx9etumoKvAlUZav2bdcZtoHdgssnb4VTpJ
         sPOZnefDiYyKeWH9vtAtdeGpsP7z+baQBXFxg=
Message-ID: <48A0BE8A.5080600@gmail.com>
Date: Mon, 11 Aug 2008 18:34:50 -0400
From: Ryan Hope <rmh3093@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080805)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Reiserfs mailing list <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3][reiser4] use wake_up_process() instead of wake_up() when
 possible
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was item #6 on the todo list for reiser4 inclusion in mainline:

diff --git a/fs/reiser4/entd.c b/fs/reiser4/entd.c
index ecdfde6..9fd4d6e 100644
--- a/fs/reiser4/entd.c
+++ b/fs/reiser4/entd.c
@@ -218,7 +218,7 @@ void reiser4_leave_flush(struct super_block *super)
  #endif
  	spin_unlock(&ent->guard);
  	if (wake_up_ent)
-		wake_up(&ent->wait);
+		wake_up_process(ent->tsk);
  }

  #define ENTD_CAPTURE_APAGE_BURST SWAP_CLUSTER_MAX
@@ -304,7 +304,7 @@ int write_page_by_ent(struct page *page, struct 
writeback_control *wbc)
  	ent->nr_todo_reqs++;
  	list_add_tail(&rq.link, &ent->todo_list);
  	if (ent->nr_todo_reqs == 1)
-		wake_up(&ent->wait);
+		wake_up_process(ent->tsk);

  	spin_unlock(&ent->guard);


-Ryan
