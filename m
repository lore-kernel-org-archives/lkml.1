Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab0BCPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:25:57 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54555 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab0BCPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:25:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=kc2tqk8ihBE8B1vhEHNQF+KMMoeKrxyNqJkTCLTQ27kvZR5kwY6RgOdQQINoZXwhTA
         pek+BnDGBvklT5pE9W0z/5ymdhCj78/yuw70UfZIKff2HPzbyLUOwLFo5+79lRBdP5je
         3DtkINRz9WCOUbwFsFL7JmO3Z+bf8GOLtsLPw=
Subject: [PATCH][mmotm-2010-02-01-16-25] Fix wrong accouting of anon and
 file
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       David Rientjes <rientjes@google.com>, linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 00:25:39 +0900
Message-ID: <1265210739.1052.36.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, Kame said he doesn't support this series.
I am not sure we need this patch or revert patch.

Who need this?

David. Do you want to remain this patch in mmotm for your OOM patch 
in future?

If anyone doesn't reply my question, Do we have to make revert patch?

== CUT_HERE == 

mm-count-lowmem-rss.patch added lowmem accouting.
But it changed file and rss accouting by mistake.
Unfortunately my review also doesn't found it.

This patch fixes it.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/memory.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3becdc3..ce8ff9d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -210,14 +210,14 @@ void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
 
 unsigned long get_file_rss(struct mm_struct *mm)
 {
-	return get_mm_counter(mm, MM_ANONPAGES)
-		+ get_mm_counter(mm, MM_ANON_LOWPAGES);
+	return get_mm_counter(mm, MM_FILEPAGES)
+		+ get_mm_counter(mm, MM_FILE_LOWPAGES);
 }
 
 unsigned long get_anon_rss(struct mm_struct *mm)
 {
-	return get_mm_counter(mm, MM_FILEPAGES)
-		+ get_mm_counter(mm, MM_FILE_LOWPAGES);
+	return get_mm_counter(mm, MM_ANONPAGES)
+		+ get_mm_counter(mm, MM_ANON_LOWPAGES);
 }
 
 unsigned long get_low_rss(struct mm_struct *mm)
-- 
1.6.5



-- 
Kind regards,
Minchan Kim


