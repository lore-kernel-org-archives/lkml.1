Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbYDTKsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbYDTKsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759490AbYDTKkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56343 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbYDTKku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/36] Kobject: Replace list_for_each() with list_for_each_entry().
Date: Sun, 20 Apr 2008 03:45:56 -0700
Message-Id: <1208688366-9252-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Use the more concise list_for_each_entry(), which allows for the
deletion of the to_kobj() routine at the same time.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 60ae9e8..2c64903 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -58,11 +58,6 @@ static int create_dir(struct kobject *kobj)
 	return error;
 }
 
-static inline struct kobject *to_kobj(struct list_head *entry)
-{
-	return container_of(entry, struct kobject, entry);
-}
-
 static int get_kobj_path_length(struct kobject *kobj)
 {
 	int length = 1;
@@ -752,12 +747,11 @@ void kset_unregister(struct kset *k)
  */
 struct kobject *kset_find_obj(struct kset *kset, const char *name)
 {
-	struct list_head *entry;
+	struct kobject *k;
 	struct kobject *ret = NULL;
 
 	spin_lock(&kset->list_lock);
-	list_for_each(entry, &kset->list) {
-		struct kobject *k = to_kobj(entry);
+	list_for_each_entry(k, &kset->list, entry) {
 		if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
 			ret = kobject_get(k);
 			break;
-- 
1.5.4.5

