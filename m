Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbZL3Qzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbZL3Qzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZL3Qzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:55:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43229 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZL3Qzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:55:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=oQRRYXzOhC55QvJXSlINlnx2Dct+Lkku7EPtfGrv2gu7e60chG73wCiJOlD/8OTcb5
         ERpB+0K5nD64X8BjFIsdnzG5qSpLVtCxDN0zAl0zR98oYHyS2yevc1DKjcChVs3E1uvb
         /pri2UYr3ooy1g7LwNZaObEtNXfvnrN1JzbNw=
Message-ID: <4B3B86CC.5010205@gmail.com>
Date: Wed, 30 Dec 2009 17:58:52 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "James E.J. Bottomley" <James.Bottomley@suse.de>,
       linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, kashyap.desai@lsi.com
Subject: [PATCH] mpt2sas: Fix &&/|| confusion in _scsih_sas_device_status_change_event()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This never evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index efabea1..82c5474 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4363,7 +4363,7 @@ _scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
 #endif
 
 	if (!(event_data->ReasonCode ==
-	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
+	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET ||
 	   event_data->ReasonCode ==
 	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET))
 		return;
