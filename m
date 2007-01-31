Return-Path: <linux-kernel-owner+w=401wt.eu-S1030484AbXAaUri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484AbXAaUri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030568AbXAaUri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:47:38 -0500
Received: from relay01.mail-hub.dodo.com.au ([203.220.32.149]:57422 "EHLO
	relay01.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030484AbXAaUri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:47:38 -0500
From: Grant Coady <grant_lkml@dodo.com.au>
To: gregkh@suse.de, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] 20-rc6-mm3: kernel/params.c: compile fail when CONFIG_SYSFS not set
Date: Thu, 01 Feb 2007 07:47:33 +1100
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <d1v1s29p013gb7etomovojr3l1duh99hca@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

This patch is a guess at what's missing, to fix a compile failure when 
CONFIG_SYSFS not set, going by nearby context.  Please check (or forward 
to someone) as I'm not sure if this is the right thing to do here.  
Compile tested.

kernel/profile.c:247: warning: 'profile_flip_buffers' defined but not used
kernel/profile.c:270: warning: 'profile_discard_flip_buffers' defined but not used
kernel/profile.c:337: warning: 'profile_cpu_callback' defined but not used
kernel/params.c:700: error: `module_uevent_ops' undeclared here (not in a function)
kernel/params.c:700: error: initializer element is not constant
kernel/params.c:700: error: (near initialization for `module_subsys.kset.uevent_ops')
kernel/params.c:700: error: initializer element is not constant
kernel/params.c:700: error: (near initialization for `module_subsys.kset')
make[1]: *** [kernel/params.o] Error 1
make: *** [kernel] Error 2

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 params.c |    4 ++++
 1 files changed, 4 insertions(+)

--- linux-2.6.20-rc6-mm3/kernel/params.c	2007-01-30 16:25:34.000000000 +1100
+++ linux-2.6.20-rc6-mm3c/kernel/params.c	2007-02-01 07:25:09.000000000 +1100
@@ -691,6 +691,10 @@
 	.show = NULL,
 	.store = NULL,
 };
+
+static struct kset_uevent_ops module_uevent_ops = {
+	.filter = NULL,
+};
 #endif
 
 static struct kobj_type module_ktype = {
