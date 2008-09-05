Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYIEVfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYIEVfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYIEVfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:35:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:34769 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYIEVfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ZNJzZL2Eg517oxEbPg9oBndde81iX54RvrjNjruV4vd+HPBOeONLd+EGd4jzL5YoWo
         eDWimKb+bb88xPixGDwNZA+/QJ/SEbCzOEZCc9/Uv/3Hht7RC9bIOy+UgjAGlXuyYXBh
         Ey0TxokPWbjdEQ85B/YN382BApWctvdYGHdXs=
Date: Sat, 6 Sep 2008 01:36:46 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: more debugging for "already registered" case
Message-ID: <20080905213646.GF11569@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print parent directory name as well.

Target is to catch non-creation of parent directory when proc_mkdir will
return NULL and all subsequent registrations go directly in /proc
instead of intended directory.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -547,8 +547,8 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 
 	for (tmp = dir->subdir; tmp; tmp = tmp->next)
 		if (strcmp(tmp->name, dp->name) == 0) {
-			printk(KERN_WARNING "proc_dir_entry '%s' already "
-					"registered\n", dp->name);
+			printk(KERN_WARNING "proc_dir_entry '%s'/'%s' already "
+					"registered\n", dir->name, dp->name);
 			dump_stack();
 			break;
 		}

