Return-Path: <linux-kernel-owner+w=401wt.eu-S935958AbYD1X4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935958AbYD1X4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935371AbYD1X4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:56:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:60308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935154AbYD1X4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:56:06 -0400
Subject: patch klist-implement-klist_init-and-define_klist.patch added to gregkh-2.6 tree
To: htejun@gmail.com, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       gregkh@suse.de, greg@kroah.com, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       stern@rowland.harvard.edu
From: <gregkh@suse.de>
Date: Mon, 28 Apr 2008 16:51:32 -0700
In-Reply-To: <48121FE4.5010803@gmail.com>
Message-ID: <12094266922694@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: klist: implement KLIST_INIT() and DEFINE_KLIST()

to my gregkh-2.6 tree.  Its filename is

     klist-implement-klist_init-and-define_klist.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From linux-usb-owner@vger.kernel.org Fri Apr 25 11:19:08 2008
From: Tejun Heo <htejun@gmail.com>
Date: Sat, 26 Apr 2008 03:16:04 +0900
Subject: klist: implement KLIST_INIT() and DEFINE_KLIST()
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@linux-foundation.org>, oliver@neukum.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, zaitcev@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Message-ID: <48121FE4.5010803@gmail.com>


klist is missing static initializers and definition helper.  Add them.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/klist.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -25,6 +25,14 @@ struct klist {
 	void			(*put)(struct klist_node *);
 };
 
+#define KLIST_INIT(_name, _get, _put)					\
+	{ .k_lock	= __SPIN_LOCK_UNLOCKED(_name.k_lock),		\
+	  .k_list	= LIST_HEAD_INIT(_name.k_list),			\
+	  .get		= _get,						\
+	  .put		= _put, }
+
+#define DEFINE_KLIST(_name, _get, _put)					\
+	struct klist _name = KLIST_INIT(_name, _get, _put)
 
 extern void klist_init(struct klist * k, void (*get)(struct klist_node *),
 		       void (*put)(struct klist_node *));


Patches currently in gregkh-2.6 which might be from htejun@gmail.com are

driver-core/sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch
driver-core/klist-implement-klist_add_-after-before.patch
driver-core/klist-implement-klist_init-and-define_klist.patch
