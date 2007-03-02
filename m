Return-Path: <linux-kernel-owner+w=401wt.eu-S1422643AbXCBIpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422643AbXCBIpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 03:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933139AbXCBIpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 03:45:33 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:35707 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbXCBIpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 03:45:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FdgSj74nF/oDbhYaX9E2fJSHF9zBXONWltesWZGjfA7D4slheAeYRjIgLJIU1KWNUZIJZf7CpGde3Kh+ejAsPFAE1oMzhtknb32PjL5g07u9rH1O3tW7kiPhYR9clyAsdEG73Pcjg872//Tg7TZI5UmnfdFAeJQW2YotyF2zNOA=
Date: Fri, 2 Mar 2007 17:45:30 +0900
From: Tejun Heo <htejun@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, linux-pm@lists.osdl.org, linux-ide@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 1/2 -stable] libata: add missing PM callbacks
Message-ID: <20070302084530.GN20322@htj.dyndns.org>
References: <20061122172841.0b90f042@localhost.localdomain> <Pine.LNX.4.60.0702262150460.5079@poirot.grange> <Pine.LNX.4.60.0702282201250.8832@poirot.grange> <Pine.LNX.4.60.0703012305030.7351@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0703012305030.7351@poirot.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some LLDs were missing scsi device PM callbacks while having host/port
suspend support.  Add missing ones.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
This should fix the problem you're seeing on sil680.  These patches
are against 2.6.20.1.  Patches for libata-dev#upstream is separately
posted to linux-ide in the following thread.

  http://thread.gmane.org/gmane.linux.ide/16475

 drivers/ata/pata_jmicron.c |    4 ++++
 drivers/ata/pata_sil680.c  |    4 ++++
 2 files changed, 8 insertions(+)

Index: work1/drivers/ata/pata_sil680.c
===================================================================
--- work1.orig/drivers/ata/pata_sil680.c
+++ work1/drivers/ata/pata_sil680.c
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
Index: work1/drivers/ata/pata_jmicron.c
===================================================================
--- work1.orig/drivers/ata/pata_jmicron.c
+++ work1/drivers/ata/pata_jmicron.c
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
