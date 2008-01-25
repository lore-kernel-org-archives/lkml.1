Return-Path: <linux-kernel-owner+w=401wt.eu-S1765776AbYAYIac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765776AbYAYIac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764104AbYAYIBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:53720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764046AbYAYIAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:00:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 135/196] Kobject: convert mm/slub.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:32:44 -0800
Message-Id: <1201246425-5058-56-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/slub.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d26177f..5cc4b7d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4025,13 +4025,12 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		name = create_unique_id(s);
 	}
 
-	kobject_set_name(&s->kobj, name);
 	s->kobj.kset = slab_kset;
-	s->kobj.ktype = &slab_ktype;
-	kobject_init(&s->kobj);
-	err = kobject_add(&s->kobj);
-	if (err)
+	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, name);
+	if (err) {
+		kobject_put(&s->kobj);
 		return err;
+	}
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
 	if (err)
-- 
1.5.3.8

