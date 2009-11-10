Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbZKJWgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbZKJWgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbZKJWgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:36:35 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:38262 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbZKJWge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:36:34 -0500
Subject: [PATCH v3 0/5] 
To: akpm@linux-foundation.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com
Date: Tue, 10 Nov 2009 15:36:38 -0700
Message-ID: <20091110223154.25636.48462.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v3 of the series.

I based it off of Linus's latest tree. 

I did not include David Rientjes's "mm: slab allocate memory section nodemask
for large systems" patch in my series, since it's not necessarily related.

Please consider for inclusion for the next merge window (v2.6.33).

Thanks,
/ac

v2 -> v3:
	- rebased to Linus's latest tree (799dd75b)
	- Added David Rientjes's Acked-by: flags
	- dropped S390 cc's, since they are unaffected by this series

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
 Documentation/ABI/testing/sysfs-devices-system-cpu |   14 +++++
 Documentation/memory-hotplug.txt                   |   11 ++--
 drivers/base/node.c                                |   58 ++++++++++++++------
 4 files changed, 76 insertions(+), 21 deletions(-)

