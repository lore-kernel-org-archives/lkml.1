Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbZDQTIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbZDQTIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZDQTHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:07:25 -0400
Received: from kroah.org ([198.145.64.141]:51197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753516AbZDQTHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:07:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/10] driver core: allow non-root users to listen to uevents
Date: Fri, 17 Apr 2009 12:04:27 -0700
Message-Id: <1239995074-4065-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090417190144.GB3548@kroah.com>
References: <20090417190144.GB3548@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Users can read sysfs files, there is no reason they should not be
allowed to listen to uevents.  This lets xorg and other userspace
programs properly get these messages without having to be root.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index dafeecf..920a3ca 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -328,7 +328,7 @@ static int __init kobject_uevent_init(void)
 		       "kobject_uevent: unable to create netlink socket!\n");
 		return -ENODEV;
 	}
-
+	netlink_set_nonroot(NETLINK_KOBJECT_UEVENT, NL_NONROOT_RECV);
 	return 0;
 }
 
-- 
1.6.2

