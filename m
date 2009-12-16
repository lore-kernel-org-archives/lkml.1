Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbZLPDIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbZLPDIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760404AbZLPDI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:08:29 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52272 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760361AbZLPDIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:08:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 12:05:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, andi@firstfloor.org,
       minchan.kim@gmail.com
Subject: [mm][RFC][PATCH 5/11] mm accessor for tomoyo
Message-Id: <20091216120519.b65addb7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace mmap_sem with mm_accessor().
for security layer.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 security/tomoyo/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: mmotm-mm-accessor/security/tomoyo/common.c
===================================================================
--- mmotm-mm-accessor.orig/security/tomoyo/common.c
+++ mmotm-mm-accessor/security/tomoyo/common.c
@@ -759,14 +759,14 @@ static const char *tomoyo_get_exe(void)
 
 	if (!mm)
 		return NULL;
-	down_read(&mm->mmap_sem);
+	mm_read_lock(mm);
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {
 			cp = tomoyo_realpath_from_path(&vma->vm_file->f_path);
 			break;
 		}
 	}
-	up_read(&mm->mmap_sem);
+	mm_read_unlock(mm);
 	return cp;
 }
 

