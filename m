Return-Path: <linux-kernel-owner+w=401wt.eu-S1422857AbXCGRQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422857AbXCGRQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422862AbXCGRQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:16:24 -0500
Received: from ns1.suse.de ([195.135.220.2]:44043 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422853AbXCGRQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:15 -0500
Message-Id: <20070307171437.505155171@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>
Subject: [patch 060/101] libata: add missing PM callbacks
Content-Disposition: inline; filename=libata-add-missing-pm-callbacks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Some LLDs were missing scsi device PM callbacks while having host/port
suspend support.  Add missing ones.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_jmicron.c |    4 ++++
 drivers/ata/pata_sil680.c  |    4 ++++
 2 files changed, 8 insertions(+)

--- linux-2.6.20.1.orig/drivers/ata/pata_jmicron.c
+++ linux-2.6.20.1/drivers/ata/pata_jmicron.c
@@ -137,6 +137,10 @@ static struct scsi_host_template jmicron
 	.slave_destroy		= ata_scsi_slave_destroy,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
+	.suspend		= ata_scsi_device_suspend,
+	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static const struct ata_port_operations jmicron_ops = {
--- linux-2.6.20.1.orig/drivers/ata/pata_sil680.c
+++ linux-2.6.20.1/drivers/ata/pata_sil680.c
@@ -226,6 +226,10 @@ static struct scsi_host_template sil680_
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
+	.suspend		= ata_scsi_device_suspend,
+	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static struct ata_port_operations sil680_port_ops = {

--
