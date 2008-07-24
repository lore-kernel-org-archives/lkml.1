Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYGXU14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYGXU14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbYGXU1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:27:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35481 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbYGXU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:27:41 -0400
Date: Thu, 24 Jul 2008 22:27:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [oops] sysdev: Pass the attribute to the low level sysdev show/store function
Message-ID: <20080724202711.GI20882@one.firstfloor.org>
References: <1216898844.5564.7.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216898844.5564.7.camel@marge.simson.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 01:27:24PM +0200, Mike Galbraith wrote:
> Greetings,
> 
> Oops below bisects to..

This patch should fix it.

-Andi


commit a2ab909933f8c8623282979dfa64f3e358bdb9fc
Author: Andi Kleen <ak@gargoyle.(none)>
Date:   Thu Jul 24 21:57:40 2008 +0200

    Make scheduler sysfs attributes sysdev class devices
    
    They are really class devices, but were incorrectly declared. This leads
    to crashes with the recent changes that makes non normal sysdevs
    use a different prototype.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index 6acf749..24358ca 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7641,34 +7641,34 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 }
 
 #ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *page)
+static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
+					   char *page)
 {
 	return sprintf(page, "%u\n", sched_mc_power_savings);
 }
-static ssize_t sched_mc_power_savings_store(struct sys_device *dev,
-					    struct sysdev_attribute *attr,
+static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
-		   sched_mc_power_savings_store);
+static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644, 
+			 sched_mc_power_savings_show,
+		         sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *page)
+static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
+					    char *page)
 {
 	return sprintf(page, "%u\n", sched_smt_power_savings);
 }
-static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
-					     struct sysdev_attribute *attr,
+static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
+static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644, 
+		   sched_smt_power_savings_show,
 		   sched_smt_power_savings_store);
 #endif
 
