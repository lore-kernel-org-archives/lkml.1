Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYJHKwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYJHKwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 06:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYJHKwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 06:52:36 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:10552 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYJHKwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=Ce4uwZjOmfCR7P1wMaS8mlOmbpUTtyIkNFH5eiaemfVDOzI2bjroLptpxKP5nfAtRS
         TDS66Ic0Cb0tWhyL8t6Pun2Er4OJGV9HGj1SAS+9G8RiEXvbkH/p3rLgBhaxrz57eenj
         JmNPYElHJHa/ojcuDhkmCWB1GtoN+gwEN0UQY=
Message-ID: <48EC90EC.8060306@gmail.com>
Date: Wed, 08 Oct 2008 12:52:28 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] documentation: clarify dirty_ratio and dirty_background_ratio
 description
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current documentation of dirty_ratio and dirty_background_ratio is a
bit misleading.

In the documentation we say that they are "a percentage of total system
memory", but the current page writeback policy, intead, is to apply the
percentages to the dirtyable memory, that means free pages + reclaimable
pages.

Better to be more explicit to clarify this concept.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 Documentation/filesystems/proc.txt |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index f566ad9..be69c8b 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1380,15 +1380,16 @@ causes the kernel to prefer to reclaim dentries and inodes.
 dirty_background_ratio
 ----------------------
 
-Contains, as a percentage of total system memory, the number of pages at which
-the pdflush background writeback daemon will start writing out dirty data.
+Contains, as a percentage of the dirtyable system memory (free pages +
+reclaimable pages), the number of pages at which the pdflush background
+writeback daemon will start writing out dirty data.
 
 dirty_ratio
 -----------------
 
-Contains, as a percentage of total system memory, the number of pages at which
-a process which is generating disk writes will itself start writing out dirty
-data.
+Contains, as a percentage of the dirtyable system memory (free pages +
+reclaimable pages), the number of pages at which a process which is generating
+disk writes will itself start writing out dirty data.
 
 dirty_writeback_centisecs
 -------------------------
