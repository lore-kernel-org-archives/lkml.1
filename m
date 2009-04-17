Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160AbZDQTJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbZDQTJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZDQTHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:07:31 -0400
Received: from kroah.org ([198.145.64.141]:51224 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755028AbZDQTH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:07:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/10] driver core: prevent device_for_each_child from oopsing
Date: Fri, 17 Apr 2009 12:04:32 -0700
Message-Id: <1239995074-4065-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090417190144.GB3548@kroah.com>
References: <20090417190144.GB3548@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel noticed that the wireless usb stack likes to call
device_for_each_chile() with an empty bus.  This used to work fine, but
now oopses.  This patch fixes the oops and makes the code behave like it
used to.

Reported-by: David Vrabel <david.vrabel@csr.com>
Tested-by: David Vrabel <david.vrabel@csr.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index e73c92d..d230ff4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1142,6 +1142,9 @@ int device_for_each_child(struct device *parent, void *data,
 	struct device *child;
 	int error = 0;
 
+	if (!parent->p)
+		return 0;
+
 	klist_iter_init(&parent->p->klist_children, &i);
 	while ((child = next_device(&i)) && !error)
 		error = fn(child, data);
-- 
1.6.2

