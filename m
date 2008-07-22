Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbYGVFqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbYGVFqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbYGVF0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:26:49 -0400
Received: from mx1.suse.de ([195.135.220.2]:54170 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797AbYGVF0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:26:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 74/79] sysdev: Convert the x86 mce tolerant sysdev attribute to generic attribute
Date: Mon, 21 Jul 2008 22:19:38 -0700
Message-Id: <1216703983-21448-74-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Use the new generic int attribute accessors for the x86 mce tolerant
attribute. Simple example to illustrate the new macros.

There are much more places all over the tree that could be converted
like this.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index e6a4d5f..9ab65be 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -812,12 +812,12 @@ static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
 }
 
 static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
-ACCESSOR(tolerant,tolerant,)
+static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
 ACCESSOR(check_interval,check_interval,mce_restart())
 static struct sysdev_attribute *mce_attributes[] = {
 	&attr_bank0ctl, &attr_bank1ctl, &attr_bank2ctl,
 	&attr_bank3ctl, &attr_bank4ctl, &attr_bank5ctl,
-	&attr_tolerant, &attr_check_interval, &attr_trigger,
+	&attr_tolerant.attr, &attr_check_interval, &attr_trigger,
 	NULL
 };
 
-- 
1.5.6.3

