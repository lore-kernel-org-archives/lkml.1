Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZH1S6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZH1S6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZH1S6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:58:11 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:11060 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZH1S6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=W7R/B9CtIegPesXEj5LgLJ3owF0JB5epjrhcEQwK7Xsr/+EWZKHJHEjvQ83DfpD2hk
         NSU2F4H5+MRZGoP9Mn6yZhJvtRtYvVSP/Ih0z3XC5Ln8rimjAjh3r7IAf2OuVFoAvBTl
         MQkQWSwn9ERgAXhQkqPKKrevtbwUP23Db3NF4=
Date: Fri, 28 Aug 2009 22:58:07 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drm: use proc_create_data()
Message-ID: <20090828185806.GC14499@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/gpu/drm/drm_proc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -106,7 +106,8 @@ int drm_proc_create_files(struct drm_info_list *files, int count,
 			continue;
 
 		tmp = kmalloc(sizeof(struct drm_info_node), GFP_KERNEL);
-		ent = create_proc_entry(files[i].name, S_IFREG | S_IRUGO, root);
+		ent = proc_create_data(files[i].name, S_IRUGO, root,
+				       &drm_proc_fops, tmp);
 		if (!ent) {
 			DRM_ERROR("Cannot create /proc/dri/%s/%s\n",
 				  name, files[i].name);
@@ -115,8 +116,6 @@ int drm_proc_create_files(struct drm_info_list *files, int count,
 			goto fail;
 		}
 
-		ent->proc_fops = &drm_proc_fops;
-		ent->data = tmp;
 		tmp->minor = minor;
 		tmp->info_ent = &files[i];
 		list_add(&(tmp->list), &(minor->proc_nodes.list));
