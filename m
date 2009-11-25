Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbZKYHEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbZKYHEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZKYHEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:04:52 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:56587 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZKYHEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:04:51 -0500
Message-ID: <4B0CD70F.6090600@austin.ibm.com>
Date: Wed, 25 Nov 2009 01:04:47 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
CC: Ben Herrenschmidt <benh@kernel.crashing.org>,
       paul Mackerras <paulus@samba.org>, gregkh@suse.de
Subject: [PATCH v2 0/3] Kernel handling of Dynamic Logical Partitioning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

version 2 of the patch set with updates from comments.

The Dynamic Logical Partitioning (DLPAR) capabilities of the powerpc pseries
platform allows for the addition and removal of resources (i.e. cpus,
memory, pci devices) from a partition. The removal of a resource involves
removing the resource's node from the device tree and then returning the
resource to firmware via the rtas set-indicator call.  To add a resource, it
is first obtained from firmware via the rtas set-indicator call and then a
new device tree node is created using the ibm,configure-coinnector rtas call
and added to the device tree.

The following set of patches implements the needed infrastructure to have the
kernel handle the DLPAR addition and removal of cpus (other DLPAR'able items to 
follow in future patches).  The framework for this is to create a set of probe/release 
sysfs files that will facilitate arch-specific call-outs to handle addition and 
removal of cpus to the system.

-Nathan Fontenot

1/3 - powerpc/pseries kernel DLPAR infrastructure
2/3 - Create probe/release sysfs files and the powerpc handlers
3/3 - powerpc/pseries CPU DLPAR handling 

 arch/powerpc/Kconfig                        |    4 
 arch/powerpc/include/asm/machdep.h          |    5 
 arch/powerpc/include/asm/pSeries_reconfig.h |    1 
 arch/powerpc/kernel/smp.c                   |   17 
 arch/powerpc/kernel/sysfs.c                 |   19 +
 arch/powerpc/platforms/pseries/Makefile     |    2 
 arch/powerpc/platforms/pseries/dlpar.c      |  500 +++++++++++++++++++++++++++-
 arch/powerpc/platforms/pseries/reconfig.c   |    2 
 drivers/base/cpu.c                          |   33 +
 include/linux/cpu.h                         |    4
 10 files changed, 581 insertions(+), 6 deletions(-)
