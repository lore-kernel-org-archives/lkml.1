Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbZIRO45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbZIRO45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZIRO44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:56:56 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48391 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZIRO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:56:55 -0400
Message-ID: <4AB39FB3.1020608@austin.ibm.com>
Date: Fri, 18 Sep 2009 09:56:51 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5 v2] kernel handling of dynamic logical partitioning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Dynamic Logical Partitioning (DLPAR) capabilities of the powerpc pseries
platform allows for the addition and removal of resources (i.e. cpus,
memory, pci devices) from a partition. The removal of a resource involves
removing the resource's node from the device tree and then returning the
resource to firmware via the rtas set-indicator call.  To add a resource, it
is first obtained from firmware via the rtas set-indicator call and then a
new device tree node is created using the ibm,configure-connector rtas call
and added to the device tree.

The following set of patches implements the needed infrastructure to have the
kernel handle the DLPAR addition and removal of memory and cpus (other
DLPAR'able items to follow in future patches).  The framework for this is
to create a set of probe/release sysfs files in pseries that will add or
remove the cpu or memory to the system.

The majority of the code is powerpc/pseries specific except for PATCH 3/5, so
I am cc'ing lkml.

Patches include in this set:
1/5 - DLPAR infracstructure for powerpc/pseries platform.
2/5 - Move the of_drconf_cell struct to prom.h
3/5 - Export the memory sysdev class
4/5 - Memory DLPAR handling
5/5 - CPU DLPAR handling

This also includes the following suggested fixes from the first version of the
patches sent out.
- Correct initialization of workarea_lock and reconfig notifier chain.
- Add cc_workarea struct to help understand the work buffer layout.
- Fix memory leak in cpu_probe_store()
- Use strict_strtoul
- Correct checkpatch failures.

-Nathan Fontenot
