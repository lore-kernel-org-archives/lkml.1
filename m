Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbYAYIFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbYAYIFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764071AbYAYH7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:53538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764051AbYAYH7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:41 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 170/196] Modules: remove unneeded release function
Date: Thu, 24 Jan 2008 23:33:19 -0800
Message-Id: <1201246425-5058-91-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that kobjects properly clean up their name structures, no matter if
they have a release function or not, we can drop this empty module
kobject release function too (it was needed prior to this because of the
way we handled static kobject names, we based the fact that if a release
function was present, then we could safely free the name string, now we
are more smart about things and only free names we have previously set.)

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/params.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 1078b14..b4da950 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -694,18 +694,8 @@ static struct kset_uevent_ops module_uevent_ops = {
 struct kset *module_kset;
 int module_sysfs_initialized;
 
-static void module_release(struct kobject *kobj)
-{
-	/*
-	 * Stupid empty release function to allow the memory for the kobject to
-	 * be properly cleaned up.  This will not need to be present for 2.6.25
-	 * with the upcoming kobject core rework.
-	 */
-}
-
 struct kobj_type module_ktype = {
 	.sysfs_ops =	&module_sysfs_ops,
-	.release =	module_release,
 };
 
 /*
-- 
1.5.3.8

