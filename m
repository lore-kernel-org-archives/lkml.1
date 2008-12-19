Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbYLSXZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbYLSXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYLSXZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:25:05 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:37350 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754475AbYLSXZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:25:04 -0500
X-YMail-OSG: c.q4b2gVM1lLQpjs1sprz9lTDLWAxrnisSCn.e5Hg9M6LQFYMPceSVT.2Y7Ad8JmJcjuX20edJ1VMZ62bAK5IhRqkvRsxYYLJ0En_4ILqpdB0KZd0sCzOLzCIaq_GV_bfzLEeYUsG201s23HqBD06f2I79C7NKNDpqnLoswyonj1LTASqXyLVWgX4T2rjHKDWnPgCj6ekt.EggY5deq99kZQqYdXqRM-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [Target_Core_Mod 0/6] More update for generic
	functionality in v3.0
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 15:24:33 -0800
Message-Id: <1229729073.4560.82.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

This patch set for Target_Core_Mod continues the process of making iSCSI
and LIO-Target specific code into generic code that is intended to be
used used across multiple $FABRIC_MODs.  This patch also includes using
kmem_cache() for se_cmd_t and se_session_t data structures, and updates
to transport_[register,deregister]_session().

Also included is a change to the Target_Core_Mod/PSCSI subsystem plugin
for v2.6.28 that involves setting struct bio->bi_bdev w/o
bio_add_pc_page() now that scsi_execute_async() have been removed for
v2.6.28-FINAL.

They are made against against lio-core-2.6.git/master and tested on
v2.6.28-rc7.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

--nab

 drivers/lio-core/target_core_base.h       |   32 +++--
 drivers/lio-core/target_core_device.c     |   44 +++++-
 drivers/lio-core/target_core_device.h     |    1 +
 drivers/lio-core/target_core_fabric_ops.h |    6 +-
 drivers/lio-core/target_core_pscsi.c      |   36 ++++-
 drivers/lio-core/target_core_pscsi.h      |    1 +
 drivers/lio-core/target_core_tpg.c        |   20 ++-
 drivers/lio-core/target_core_tpg.h        |    4 +-
 drivers/lio-core/target_core_transport.c  |  247 +++++++++++++++--------------
 drivers/lio-core/target_core_transport.h  |    6 +-
 10 files changed, 249 insertions(+), 148 deletions(-)

[PATCH] [Target_Core_Mod 1/6] Updates for core data structures
[PATCH] [Target_Core_Mod 2/6]: Update struct target_core_fabric_ops
[PATCH] [Target_Core_Mod 3/6]: Updates for transport_[register,deregister]_session() logic
[PATCH] [Target_Core_Mod 4/6]: Updates for generic portal group functionality
[PATCH] [Target_Core_Mod 5/6]: Updates for generic device core
[PATCH] [Target_Core_Mod/PSCSI 6/6]: Grab temporary pointer to struct block_device for BIO for v2.6.28


