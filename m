Return-Path: <linux-kernel-owner+w=401wt.eu-S932956AbZKYRIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956AbZKYRIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932906AbZKYRI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:08:29 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60004 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846AbZKYRI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:08:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=o9NZcZAw9DGAysiVh73K5bgAk/JaEbuY7XQiJYTFrV9OLkuSAfr0mxHrbJDZmbUj+s
         FQ45BSa3bvM9XXHF8cU7qhiOPl/3TeklcpCZox96XMiSDnAN9Wgs/LKJJWLlEAv9fGnm
         6oz2RUvLPndSuW+5zOLXmc4TxsZ9WaeOxX+Zg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:07:48 +0100
Message-Id: <20091125170748.5446.82207.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 46/86] pata_legacy: fix QDI6580DP support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_legacy: fix QDI6580DP support

Dual port QDI6580 has shared PIO timings for master/slave
devices so it needs to use custom ->qc_issue method.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_legacy.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ata/pata_legacy.c
===================================================================
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -787,6 +787,7 @@ static struct ata_port_operations qdi658
 static struct ata_port_operations qdi6580dp_port_ops = {
 	.inherits	= &legacy_base_port_ops,
 	.set_piomode	= qdi6580dp_set_piomode,
+	.qc_issue	= qdi_qc_issue,
 	.sff_data_xfer	= vlb32_data_xfer,
 };
 
