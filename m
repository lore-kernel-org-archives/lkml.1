Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZCYGFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZCYGFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 02:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZCYGFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 02:05:24 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:39874 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752585AbZCYGFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 02:05:24 -0400
X-YMail-OSG: Kv5EXeAVM1k9_7pnEJ7RWtTi1YZVVr8F2mTdaUKcx8xKbSNDsCp1bLEnZHP_BEXm2yhm5DYWUZIrgAWeRrP7J3__YvJ1C2Af0i4FywORm0W8uvDdI1P36NNkRYnAvzc5WbCzNg.Du1A3KnHW8WEG57f8PdKTPZgS97dH0NtSEtubsjKWrefkds9XIOkPh6pm6pqn_0E8zQmC4TATvupfKoyME6qkJBE-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 0/2] [Target_Core_Mod]: Add support for UNIT_ATTENTION with
	SPC-3 PR
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Douglas Gilbert <dgilbert@interlog.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
       Boaz Harrosh <bharrosh@panasas.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 23:05:20 -0700
Message-Id: <1237961120.4138.416.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

This patch adds support for SAM4/SPC4 compliant UNIT_ATTENTION with ua_intlck_ctrl 
control mode page value 00b, 10b and 11b.  The default has been set to 0 in configfs,
which is to clear the UNIT ATTENTION with a CHECK_CONDITION+Sense data with a
corresponding ASC+ASCQ.  Currently, Linux/SCSI midlayer clients require a manual sg_request
to clear the UNIT ATTENTION with a REQUEST_SENSE for modes 10b and 11b.  These values can be
changed (without active $FABRIC_MOD target ports) for a given target_core_mod storage object
with ConfigFS via /sys/kernel/config/target/core/$HBA/$DEV/attrib/emulated_ua_intlck_ctrl.
The echoed values for the attribute into ConfigFS are 0, 1, and 2 respectively for the
interlock codes 00b, 10b, and 11b.

These patches are made against lio-core-2.6.git/master and tested on
v2.6.29 x86 32-bit HVM using sg_persist from sg3_utils.  The lio-core-2.6.git tree
can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Subject: [PATCH 1/2] [Target_Core_Mod]: Add support for UNIT_ATTENTION conditions
Subject: [PATCH 2/2] [Target_Core_Mod/Persistent_Reservations]: Add UNIT ATTENTION support for PROUT SAs 

 drivers/lio-core/Makefile                |    1 +
 drivers/lio-core/target_core_base.h      |   13 ++
 drivers/lio-core/target_core_configfs.c  |    4 +
 drivers/lio-core/target_core_device.c    |   27 +++-
 drivers/lio-core/target_core_device.h    |    1 +
 drivers/lio-core/target_core_pr.c        |  107 +++++++++-
 drivers/lio-core/target_core_tpg.c       |   10 +
 drivers/lio-core/target_core_transport.c |  127 ++++++++++--
 drivers/lio-core/target_core_transport.h |    2 +
 drivers/lio-core/target_core_ua.c        |  333 ++++++++++++++++++++++++++++++
 drivers/lio-core/target_core_ua.h        |   36 ++++
 11 files changed, 632 insertions(+), 29 deletions(-)


