Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbZE2OzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbZE2OzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbZE2OzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:55:08 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:32954 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215AbZE2OzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:55:07 -0400
Date: Fri, 29 May 2009 09:55:30 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LKML-SCSI <linux-scsi@vger.kernel.org>
Subject: [andrew.patterson@hp.com: [PATCH v6] cciss: add cciss driver sysfs entries]
Message-ID: <20090529145530.GD4846@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fat fingered Andrew & Jens' addresses. Sorry for nay duplicates.
----- Forwarded message from Andrew Patterson <andrew.patterson@hp.com> -----

Date: Mon, 13 Apr 2009 10:45:25 -0600
From: Andrew Patterson <andrew.patterson@hp.com>
To: mikem@beardog.cca.cpqcorp.net
Cc: gerry.morong@hp.com, andrew.patterson@hp.com,
	scameron@beardog.cca.cpqcorp.net, scott.benesh@hp.com
Subject: [PATCH v6] cciss: add cciss driver sysfs entries

This is version six of my patch to add sysfs entries to the cciss driver.

Changelog:

Version 3
Got rid of /sys/class/cciss_* entries.  Now only show vendor, model, 
rev, and unique_id at /sys/bus/pci/devices/ccissX/cXdY.  Where X is the
controller nubmer and Y is the logical drive number.
Fixed a double memcpy of the serial number.
Documented new sysfs entries in 
Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
Fixed tabs in Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
Removed unneeded device_attribute release functions
Fixed pahole-reported holes.

Version 4
Moved cciss_sysfs.c into cciss.c
Added cciss_bus_type to logical drive so we get /sys/bus/cciss/device/ccissX.

Version 5 
Added cciss_bus_type to hba so we get /sys/bus/cciss/device/cYdZ.

Version 6

Use "sizeof() + 1" instead of "*LEN + 2" for *_show() routines.
Added back in ABI docs.
The following patch adds sysfs entries for the cciss driver. It adds
vendor, model, rev, and unique_id under /sys/block/cciss!c#d#/device
needed for RedHat BZ:

   https://bugzilla.redhat.com/show_bug.cgi?id=484419

This patch is based off os linus's 2.6 tree (2.6.30-rc1).

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |   33 ++
 drivers/block/cciss.c                              |  267 ++++++++++++++++++++
 drivers/block/cciss.h                              |   24 +-
 3 files changed, 314 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-pci-devices-cciss


-- 
Andrew Patterson


----- End forwarded message -----
