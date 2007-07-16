Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXGPOF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXGPOF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932468AbXGPOFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:05:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:47619 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458AbXGPOFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=h7cw+BwCCtR80UuhyovWp+SWn4AkUiAOtVmBzn7ScFSULCWzdYm5f4Re3y/h2YXt0jSmjK1JRAy8h0NzesQL7KthPxXJx9SaW6idrm5bU3EUifocozWEXLNDh0qdsz+uPZlAmlgK81K6iny9gUpgkT3UuqVIYBJvQvS7eoZyBX0=
Date: Mon, 16 Jul 2007 22:54:56 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/10] topology: remove topology_dev_map
Message-ID: <20070716135456.GE2040@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20070716134855.GA1858@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134855.GA1858@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By previous cpu hotplug notifier change, we don't need to track
topology_dev existence for each cpu by topology_dev_map.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/base/topology.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

Index: 2.6-mm/drivers/base/topology.c
===================================================================
--- 2.6-mm.orig/drivers/base/topology.c
+++ 2.6-mm/drivers/base/topology.c
@@ -94,27 +94,18 @@ static struct attribute_group topology_a
 	.name = "topology"
 };
 
-static cpumask_t topology_dev_map = CPU_MASK_NONE;
-
 /* Add/Remove cpu_topology interface for CPU device */
 static int __cpuinit topology_add_dev(unsigned int cpu)
 {
-	int rc;
 	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
 
-	rc = sysfs_create_group(&sys_dev->kobj, &topology_attr_group);
-	if (!rc)
-		cpu_set(cpu, topology_dev_map);
-	return rc;
+	return sysfs_create_group(&sys_dev->kobj, &topology_attr_group);
 }
 
 static void __cpuinit topology_remove_dev(unsigned int cpu)
 {
 	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
 
-	if (!cpu_isset(cpu, topology_dev_map))
-		return;
-	cpu_clear(cpu, topology_dev_map);
 	sysfs_remove_group(&sys_dev->kobj, &topology_attr_group);
 }
 
