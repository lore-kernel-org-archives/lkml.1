Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXCFVy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXCFVy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030310AbXCFVy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:54:59 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34699 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224AbXCFVy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:54:58 -0500
Subject: Re: [PATCH 1/2] ibmebus: dynamic addiiton/removal of adapters,
	uevent, root device based on struct device
From: John Rose <johnrose@austin.ibm.com>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, External List <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, Me Notes <johnrose@us.ibm.com>,
       Joaquim Fenkes <fenkes@de.ibm.com>, Paul Mackerras <pmac@au1.ibm.com>,
       stefan.roscher@de.ibm.com, Nathan Fontenot <nfont@austin.ibm.com>
In-Reply-To: <200702230137.24348.hnguyen@linux.vnet.ibm.com>
References: <200702230137.24348.hnguyen@linux.vnet.ibm.com>
Content-Type: text/plain
Message-Id: <1173217902.15589.33.camel@sinatra.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.6 (1.4.6-2) 
Date: Tue, 06 Mar 2007 15:51:42 -0600
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This adds two sysfs attributes to /sys/bus/ibmebus which can
> be used to notify the ebus driver of added / removed ebus
> devices in the OF device tree.

We are seeing several build errors when attempting to apply this to
2.6.21-rc2:

CC arch/powerpc/kernel/ibmebus.o
arch/powerpc/kernel/ibmebus.c: In function "ibmebus_register_device_common":
arch/powerpc/kernel/ibmebus.c:192: warning: ignoring return value of "device_create_file", declared with attribute warn_unused_result
arch/powerpc/kernel/ibmebus.c: At top level:
arch/powerpc/kernel/ibmebus.c:373: error: "of_device_uevent" undeclared here (not in a function)
arch/powerpc/kernel/ibmebus.c: In function "ibmebus_store_probe":
arch/powerpc/kernel/ibmebus.c:399: error: assignment of read-only location
arch/powerpc/kernel/ibmebus.c:401: error: assignment of read-only location
arch/powerpc/kernel/ibmebus.c: In function "ibmebus_store_remove":
arch/powerpc/kernel/ibmebus.c:434: error: assignment of read-only location
arch/powerpc/kernel/ibmebus.c:436: error: assignment of read-only location
arch/powerpc/kernel/ibmebus.c: In function "ibmebus_bus_init":
arch/powerpc/kernel/ibmebus.c:474: warning: ignoring return value of "bus_create_file", declared with attribute warn_unused_result
arch/powerpc/kernel/ibmebus.c:475: warning: ignoring return value of "bus_create_file", declared with attribute warn_unused_result
make[1]: *** [arch/powerpc/kernel/ibmebus.o] Error 1
make: *** [arch/powerpc/kernel] Error 2
make: *** Waiting for unfinished jobs....
Here is a sample error from the patch referenced above:
+static ssize_t ibmebus_store_probe(struct bus_type *bus,
+                                  const char *buf, size_t count)
+{
+       struct device_node *dn = NULL;
+       struct ibmebus_dev *dev;
+       char *loc_code;
+
+       buf[count] = '\0';

The "buf" variable is declared const, and then immediately written to.

Thanks-
John

