Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZGBFcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZGBFcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZGBFbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:31:50 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58731 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZGBFbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g7JX/TTa9UD4Eg4Dwl9nw00SsUOW1eLudLa9Qj7URlh3RQpKIWODDFnA8kkTfxQu58
         7M63CxC/RCKK2IF3gU25bdSi4dBDozGSIFUBdbK0B1e+QqoFVEx0/w8r7Q48a9Yb06VI
         2BpWSzzdjxXBMx9USHv+XsPYdc/qTNEpAyBCs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/8] SELinux avc.c non-trivial fixes.
Date: Wed,  1 Jul 2009 22:32:40 -0700
Message-Id: <1246512767-2999-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
References: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Fix some comments.
Adjust comment  to look like the other comments.
---
 security/selinux/avc.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index b2ab608..ce3b885 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -397,7 +397,7 @@ static inline struct avc_node *avc_search_node(u32 ssid, u32 tsid, u16 tclass)
  * Look up an AVC entry that is valid for the
  * (@ssid, @tsid), interpreting the permissions
  * based on @tclass.  If a valid AVC entry exists,
- * then this function return the avc_node.
+ * then this function returns the avc_node.
  * Otherwise, this function returns NULL.
  */
 static struct avc_node *avc_lookup(u32 ssid, u32 tsid, u16 tclass)
@@ -701,7 +701,7 @@ void avc_audit(u32 ssid, u32 tsid,
  * @perms: permissions
  *
  * Register a callback function for events in the set @events
- * related to the SID pair (@ssid, @tsid) and
+ * related to the SID pair (@ssid, @tsid) 
  * and the permissions @perms, interpreting
  * @perms based on @tclass.  Returns %0 on success or
  * -%ENOMEM if insufficient memory exists to add the callback.
@@ -739,14 +739,17 @@ static inline int avc_sidcmp(u32 x, u32 y)
 
 /**
  * avc_update_node Update an AVC entry
- * @event : Updating event
- * @perms : Permission mask bits
- * @ssid,@tsid,@tclass : identifier of an AVC entry
- * @seqno : sequence number when decision was made
+ * @event: Updating event
+ * @perms: Permission mask bits
+ * @ssid: source security identifier
+ * @tsid: target security identifier
+ * @tclass: target security class
+ * @seqno : policy sequence number 
  *
- * if a valid AVC entry doesn't exist,this function returns -ENOENT.
- * if kmalloc() called internal returns NULL, this function returns -ENOMEM.
- * otherwise, this function update the AVC entry. The original AVC-entry object
+ * If a valid AVC entry doesn't exist, this function returns -ENOENT.
+ * If kmalloc() is called internaly and returns NULL, then 
+ * this function returns -ENOMEM.
+ * Otherwise this function update's the AVC entry. The original AVC-entry object
  * will release later by RCU.
  */
 static int avc_update_node(u32 event, u32 perms, u32 ssid, u32 tsid, u16 tclass,
-- 
1.6.3.2

