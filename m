Return-Path: <linux-kernel-owner+w=401wt.eu-S1751655AbZDEPyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbZDEPyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 11:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZDEPyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 11:54:21 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:64204 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZDEPyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 11:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=yFontfyaaa8PyQm/4p8zRSPH0tG6PWuCLXcFli7so4UUmz2LhF0T+WBVe61Q/aVE2e
         mpkXJt5q3rcd8cgvh4rrAiyFMsIZiyVtCJ+GrL2R4zhQ3Fs9Slnbsb7etgn+ua4Bi3zu
         S1XAhIqBmq7kZMFOerdJ1YrSLQvVCtbH4VL3E=
From: Andrea Righi <righi.andrea@gmail.com>
To: Paul Menage <menage@google.com>, Pavel Emelyanov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH] res_counter: update documentation
Date: Sun,  5 Apr 2009 17:54:13 +0200
Message-Id: <1238946853-19627-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the introduction of resource counters hierarchies
(28dbc4b6a01fb579a9441c7b81e3d3413dc452df) the prototypes of
res_counter_init() and res_counter_charge() have been changed.

Keep the documentation consistent with the actual function prototypes.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 Documentation/cgroups/resource_counter.txt |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
index f196ac1..95b24d7 100644
--- a/Documentation/cgroups/resource_counter.txt
+++ b/Documentation/cgroups/resource_counter.txt
@@ -47,13 +47,18 @@ to work with it.
 
 2. Basic accounting routines
 
- a. void res_counter_init(struct res_counter *rc)
+ a. void res_counter_init(struct res_counter *rc,
+				struct res_counter *rc_parent)
 
  	Initializes the resource counter. As usual, should be the first
 	routine called for a new counter.
 
- b. int res_counter_charge[_locked]
-			(struct res_counter *rc, unsigned long val)
+	The struct res_counter *parent can be used to define a hierarchical
+	child -> parent relationship directly in the res_counter structure,
+	NULL can be used to define no relationship.
+
+ c. int res_counter_charge(struct res_counter *rc, unsigned long val,
+				struct res_counter **limit_fail_at)
 
 	When a resource is about to be allocated it has to be accounted
 	with the appropriate resource counter (controller should determine
@@ -67,15 +72,25 @@ to work with it.
 	  * if the charging is performed first, then it should be uncharged
 	    on error path (if the one is called).
 
- c. void res_counter_uncharge[_locked]
+	If the charging fails and a hierarchical dependency exists, the
+	limit_fail_at parameter is set to the particular res_counter element
+	where the charging failed.
+
+ d. int res_counter_charge_locked
+			(struct res_counter *rc, unsigned long val)
+
+	The same as res_counter_charge(), but it must not acquire/release the
+	res_counter->lock internally (it must be called with res_counter->lock
+	held).
+
+ e. void res_counter_uncharge[_locked]
 			(struct res_counter *rc, unsigned long val)
 
 	When a resource is released (freed) it should be de-accounted
 	from the resource counter it was accounted to.  This is called
 	"uncharging".
 
-    The _locked routines imply that the res_counter->lock is taken.
-
+	The _locked routines imply that the res_counter->lock is taken.
 
  2.1 Other accounting routines
 
-- 
1.5.6.3

