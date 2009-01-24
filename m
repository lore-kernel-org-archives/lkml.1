Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZAXB4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZAXB4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 20:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZAXB4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 20:56:08 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:23437 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753716AbZAXB4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 20:56:07 -0500
X-YMail-OSG: PbawrzgVM1n1TSbcSJE7QHa6NIO0jWItJc2XEe8.AjXkxvKsFbV4j1rQ8V.kpqmq5hRS7BiILX.wQeMRyMl22zF8NY7Q9dqycJMMgV90_CYF7wgWGdpIBSJEGYh3GbFU_721iVG7q2nGaomsYsaOS_BTDt5rp7XtYLdTNTm1j.dLfLsj4QD3axgg7NbCOc__tvx2L9RLJGeXtQfLXsuLgmSZMI6npJQ-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH Target_Core_Mod]: Add T10 EVPD Unit Serial Number Emulation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@osdl.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 17:55:42 -0800
Message-Id: <1232762142.24642.12.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

This patch series adds support for T10 EVPD Unit Serial Number emulation
via ConfigFS to target_core_mod/[pSCSI,IBLOCK,FILEIO,RAMDISK] subsystem plugins.
The Linux/SCSI passthrough with pSCSI has a special consideration for firmware or
Linux/SCSI LLD emulated EVPD information.  eg: it will not let you emulate if
Target_Core_Mod/pSCSI sees active EVPD information in INQUIRY Response payloads.

This patch is made against lio-core-2.6.git/master
and tested on v2.6.28 x86 32-bit HVM.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Comments folks..?

--nab

[PATCH 1/6] [Target_Core_Mod]: Add support for configurable EVPD Unit Serial Numbers
[PATCH 2/6] [Target_Core_Mod/RAMDISK]: Update transport_generic_emulate_inquiry() usage
[PATCH 3/6] [Target_Core_Mod/FILEIO): Update for EVPD and remove legacy parameter code
[PATCH 4/6] [Target_Core_Mod/IBLOCK): Update for EVPD and remove legacy parameter code
[PATCH 5/6] [Target_Core_Mod/pSCSI]: Update EVPD post processing logic
[PATCH 6/6] [Target_Core_Mod/ConfigFS]: Add support for $STORAGE_OBJECT EVPD Unit Serial Number emulation

remote: Counting objects: 47, done.
remote: Compressing objects: 100% (34/34), done.
remote: Total 34 (delta 29), reused 0 (delta 0)
Unpacking objects: 100% (34/34), done.
>From /pub/scm/linux/kernel/git/nab/lio-core-2.6
 * branch            master     -> FETCH_HEAD
Updating 18ebd43..a50c8a5
Fast forward
 drivers/lio-core/target_core_base.h      |    2 +
 drivers/lio-core/target_core_configfs.c  |   59 +++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_file.c      |   39 +-------------------
 drivers/lio-core/target_core_file.h      |    8 +---
 drivers/lio-core/target_core_iblock.c    |   45 ++---------------------
 drivers/lio-core/target_core_iblock.h    |   12 ++----
 drivers/lio-core/target_core_pscsi.c     |   34 +++++++++++++-----
 drivers/lio-core/target_core_rd.c        |    2 +-
 drivers/lio-core/target_core_transport.c |   20 ++++++-----
 drivers/lio-core/target_core_transport.h |   13 +++++--
 10 files changed, 117 insertions(+), 117 deletions(-)


