Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZHaI36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZHaI36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZHaI35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:29:57 -0400
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:48446 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751732AbZHaI3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:29:35 -0400
X-Yahoo-SMTP: RrAacJSswBBjW0Obe5dhTHj7mfiuboERhd4hX4HvWHq2RmBoxiTUVqFaT6p3
X-YMail-OSG: ivq6sd4VM1keX0jPh37OhtJ80AcqTLZ1crAnVIi7Nwetmna9_nkntsFC0036JfT_WMChoSEIgMEdry6dlXYlunRZpwE3BauIQq8H8E20cB7k5zKtKLwEVp1P.Vqf4B00JC0jMmuJ.m9YxAs5JMrQ5TISR6D1sXcyqp.2txM98bIo6ViLZKGBGyFTkjPgeriPcZzkIqkZ15HgCebwvlCWoHptXehZxdovnoZWld5KlGGA5UtSWmvtw_1EEtu2oK2cIzy5wxWfcxXwyMglDociVqoR5QEuyGGTUDjo6iIT3g--
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 3/4] [Target_Core_Mod]: Add alua mutex initialization in
	core_alloc_port()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Alasdair G Kergon <agk@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 01:27:33 -0700
Message-Id: <1251707253.4136.42.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch updates core_alloc_port() to call mutex_init() for the
mutex protecting the ALUA secondary access state/status metadata.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index a088960..a3572ed 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -611,6 +611,7 @@ se_port_t *core_alloc_port(se_device_t *dev)
 	INIT_LIST_HEAD(&port->sep_list);
 	atomic_set(&port->sep_tg_pt_secondary_offline, 0);
 	spin_lock_init(&port->sep_alua_lock);
+	mutex_init(&port->sep_tg_pt_md_mutex);
 
 	spin_lock(&dev->se_port_lock);
 	if (dev->dev_port_count == 0x0000ffff) {
-- 
1.5.4.1



