Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbZLQErn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbZLQErn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761905AbZLQEDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:03:44 -0500
Received: from kroah.org ([198.145.64.141]:55252 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761811AbZLQEDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:37 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:44 2009
Message-Id: <20091217035644.408542787@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [011/151] PM / Runtime: Fix lockdep warning in __pm_runtime_set_status()
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit bab636b921017f0db6e0c2979438f50b898a9808 upstream.

Lockdep complains about taking the parent lock in
__pm_runtime_set_status(), so mark it as nested.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/power/runtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -777,7 +777,7 @@ int __pm_runtime_set_status(struct devic
 	}
 
 	if (parent) {
-		spin_lock(&parent->power.lock);
+		spin_lock_nested(&parent->power.lock, SINGLE_DEPTH_NESTING);
 
 		/*
 		 * It is invalid to put an active child under a parent that is


