Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYGAQtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYGAQtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYGAQss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:48:48 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:57533 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYGAQsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:48:46 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080701648.901668603@firstfloor.org>
In-Reply-To: <20080701648.901668603@firstfloor.org>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/4] Convert the x86 mce tolerant sysdev attribute to generic attribute
Message-Id: <20080701164843.EA94A1B4314@basil.firstfloor.org>
Date: Tue,  1 Jul 2008 18:48:43 +0200 (CEST)
X-OriginalArrivalTime: 01 Jul 2008 16:41:23.0070 (UTC) FILETIME=[4BF229E0:01C8DB99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the new generic int attribute accessors for the x86 mce tolerant
attribute. Simple example to illustrate the new macros. 

There are much more places all over the tree that could be converted
like this.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -785,12 +785,12 @@ static ssize_t set_trigger(struct sys_de
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
 
