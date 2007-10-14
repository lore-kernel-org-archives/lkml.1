Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbXJNLEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbXJNLEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 07:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXJNLEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 07:04:43 -0400
Received: from styx.suse.cz ([82.119.242.94]:54572 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755480AbXJNLEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 07:04:42 -0400
Date: Sun, 14 Oct 2007 13:04:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] remove GPL restriction from set_dumpable()
Message-ID: <Pine.LNX.4.64.0710141257030.20620@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

remove GPL restriction from set_dumpable()

Commit 6c5d5238 introduced a set_dumpable() function that replaced the 
direct access to mm_struct->dumpable. I don't think there is any reason to 
restrict this function to EXPORT_SYMBOL_GPL() -- previously any module 
could modify current->mm->dumpable without any resitrictions, so it makes 
a little sense to turn this into 'internal interface' at once.

There in fact are 3rd party modules that modify the dumpable flag, and 
this patch should fix the situation for them once again (for example 
vmware).

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/fs/exec.c b/fs/exec.c
index 073b0b8..a204720 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1699,7 +1699,7 @@ void set_dumpable(struct mm_struct *mm, int value)
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(set_dumpable);
+EXPORT_SYMBOL(set_dumpable);
 
 int get_dumpable(struct mm_struct *mm)
 {
