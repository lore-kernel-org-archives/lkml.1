Return-Path: <linux-kernel-owner+w=401wt.eu-S1751344AbZHIFCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbZHIFCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 01:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbZHIFCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 01:02:43 -0400
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:46152 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750757AbZHIFCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 01:02:43 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Aug 2009 01:02:42 EDT
X-Yahoo-SMTP: RrAacJSswBBjW0Obe5dhTHj7mfiuboERhd4hX4HvWHq2RmBoxiTUVqFaT6p3
X-YMail-OSG: KHGByO0VM1mqOMH_RUcz_frMsMXAZUaWGCQRdkxWgHHLP7TnTfJmD4FuKQ.lqBM_9fZHrtzA6TzeMnst2MnWZQgjeQ8SboFAIFv3AGI1Nb3bYwooPK6PcNMD0_BI9zi7HukToxIuvvCFwu36ucswlz90vEKdsSKOxdM.OImkzXyaLLVL1ee.FgLIzBhJEhfyGS4js2zecL15nW6uEs3CleGmhdnKf_yqYTHQq7FhtV.B6o1wKSVEbGEnwH7LecfV8NQF0AOiuY6O3R373IyeSPFD8RD6TCumB1W5hznQoUObM54oFs0-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 0/2] [Target_Core_Mod/Persistent_Reservations]: Add
	SPEC_I_PT=1 support
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Smart <James.Smart@Emulex.Com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Content-Type: text/plain
Date: Sat, 08 Aug 2009 21:56:02 -0700
Message-Id: <1249793762.11105.233.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again SCSI folks,

Attached are two patches for implementing the Specify Initiator Port Capable (SPEC_I_PT=1)
feature bit for handling of fabric dependent TransportIDs with PROUT service action REGISTER.
This is done by walking the PROUT parameter list, and calling fabric module dependent code for
extracting the TransportIDs and lengths, and then doing a second loop performing atomic adding
of pre-registered registrations for the fabric Initiator Ports referenced by TransportIDs.

This has been been tested with TCM/IBLOCK with fabric LIO-Target ports on v2.6.31-rc5 x86
32-bit KVM, please have a look at Patch 1 for an example using sg_persist + SPEC_I_PT=1 with
this code.

--nab

[PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Add Specify Initiator Port Capable (SPEC_I_PT=1) support
[PATCH 2/2] [LIO-Target]: Update iSCSI TransportID parser to return length

 drivers/lio-core/iscsi_target_tpg.c     |   26 ++-
 drivers/lio-core/iscsi_target_tpg.h     |    2 +-
 drivers/target/target_core_pr.c         |  445 +++++++++++++++++++++++++++++--
 include/target/target_core_fabric_ops.h |    2 +-
 4 files changed, 448 insertions(+), 27 deletions(-)


