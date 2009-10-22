Return-Path: <linux-kernel-owner+w=401wt.eu-S1751463AbZJVEPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbZJVEPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 00:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbZJVEPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 00:15:02 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:5128 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZJVEPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 00:15:01 -0400
Subject: [PATCH v2 0/5] mm: modest useability enhancements for node sysfs attrs
To: akpm@linux-foundation.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:15:05 -0600
Message-ID: <20091022040814.15705.95572.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of the series.

The last patch in this series is dependent upon the documentation patch
series that I just sent out a few moments ago:

	http://thread.gmane.org/gmane.linux.kernel/905018

Thanks,
/ac


v1 -> v2: http://thread.gmane.org/gmane.linux.kernel.mm/40084/
	Address David Rientjes's comments
	- check return value of sysfs_create_link in register_cpu_under_node
	- do /not/ convert [un]register_cpu_under_node to return void, since
	  sparse starts whinging if you ignore sysfs_create_link()'s return
	  value and working around sparse makes the code ugly
	- adjust documentation

	Added S390 maintainers to cc: for patch [1/5] as per Kame-san's
	suggestion. S390 may map a memory section to more than one node,
	causing this series to break.

---

Alex Chiang (5):
      mm: add numa node symlink for memory section in sysfs
      mm: refactor register_cpu_under_node()
      mm: refactor unregister_cpu_under_node()
      mm: add numa node symlink for cpu devices in sysfs
      Documentation: ABI: /sys/devices/system/cpu/cpu#/node


 Documentation/ABI/testing/sysfs-devices-memory     |   14 ++++-
 Documentation/ABI/testing/sysfs-devices-system-cpu |   15 +++++
 Documentation/memory-hotplug.txt                   |   11 ++--
 drivers/base/node.c                                |   58 ++++++++++++++------
 4 files changed, 77 insertions(+), 21 deletions(-)

