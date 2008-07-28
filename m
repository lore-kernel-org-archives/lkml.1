Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbYG1VwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbYG1VwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYG1VwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:52:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51547 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYG1VwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:52:08 -0400
Date: Mon, 28 Jul 2008 23:51:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sched-powersave causes oops on 2.6.26-08037-g8cd362a
Message-ID: <20080728215156.GF30344@one.firstfloor.org>
References: <1217281739.7345.8.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217281739.7345.8.camel@nimitz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 02:48:59PM -0700, Dave Hansen wrote:
> This oops just happens on startup for me.

Patch has been already posted a couple of times, here is it again.

-Andi


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
 
