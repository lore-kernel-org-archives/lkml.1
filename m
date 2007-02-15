Return-Path: <linux-kernel-owner+w=401wt.eu-S1030565AbXBOUAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030565AbXBOUAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030583AbXBOUAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:00:32 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55959 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030565AbXBOUAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:00:32 -0500
Subject: Re: [PATCH 2.6.21-rc1] ibmebus: Support dynamic addition and
	removal of adapters
From: John Rose <johnrose@austin.ibm.com>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, External List <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, Me Notes <johnrose@us.ibm.com>,
       fenkes@de.ibm.com, Paul Mackerras <pmac@au1.ibm.com>
In-Reply-To: <200702151755.13009.hnguyen@linux.vnet.ibm.com>
References: <200702151755.13009.hnguyen@linux.vnet.ibm.com>
Content-Type: text/plain
Message-Id: <1171569457.20758.76.camel@sinatra.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.6 (1.4.6-2) 
Date: Thu, 15 Feb 2007 13:57:37 -0600
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi-

Looks good.  Questions: how can the user space tools verify the success
of an add or remove?  

Also, will /sys/bus/ibmebus exist even if the system booted with no LHEA
nodes?

One more comment below.

@@ -161,7 +161,9 @@ static void __devinit ibmebus_dev_releas
 static ssize_t ibmebusdev_show_name(struct device *dev, 
 				    struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%s\n", to_ibmebus_dev(dev)->name);
+	struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
+	char *name = (char*)get_property(ebus_dev->ofdev.node, "name", NULL);
+	return sprintf(buf, "%s\n", name);
 }
 static DEVICE_ATTR(name, S_IRUSR | S_IRGRP | S_IROTH, ibmebusdev_show_name, 
 		   NULL);


Can we also have an attribute "devspec" that communicates the open
firmware path through sysfs?  User space DLPAR tools need a way to make
this correlation.  This is consistent with other dynamic-capable sysfs
objects (cpus, etc).  I assume you could get this string with something
like ebus_dev->ofdev.node->full_name.  For example:

# cat /sys/bus/ibmebus/$ebus_device/devspec
/lhea@xxxxxxxxx/

Thanks-
John

