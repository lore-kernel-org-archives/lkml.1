Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbZFVFWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbZFVFWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 01:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZFVFWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 01:22:09 -0400
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:39129 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZFVFWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 01:22:08 -0400
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: Jiri Slaby <jirislaby@gmail.com>, "Moore, Eric" <Eric.Moore@lsi.com>
CC: DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "Support, Software" <support@lsi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Jun 2009 10:52:05 +0530
Subject: RE: [PATCH] fusion: mptsas, fix lock imbalance
Thread-Topic: [PATCH] fusion: mptsas, fix lock imbalance
Thread-Index: Acnyu4I9BCduHS0LRgC7gUtiXJEGuAAPWkhg
Message-ID: <0D1E8821739E724A86F4D16902CE275C141A2C1DF0@inbmail01.lsi.com>
References: <1245621541-27008-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1245621541-27008-1-git-send-email-jirislaby@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

Consider this as ACKED patch.

- Kashyap Desai

-----Original Message-----
From: Jiri Slaby [mailto:jirislaby@gmail.com] 
Sent: Monday, June 22, 2009 3:29 AM
To: Moore, Eric
Cc: DL-MPT Fusion Linux; linux-scsi@vger.kernel.org; Support, Software; linux-kernel@vger.kernel.org; Jiri Slaby
Subject: [PATCH] fusion: mptsas, fix lock imbalance

Fix two typos in mptsas_not_responding_devices. It was mutex_lock instead
of unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/message/fusion/mptsas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 20e0b44..55ff252 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3518,7 +3518,7 @@ retry_page:
 		} else
 			mptsas_volume_delete(ioc, sas_info->fw.id);
 	}
-	mutex_lock(&ioc->sas_device_info_mutex);
+	mutex_unlock(&ioc->sas_device_info_mutex);
 
 	/* expanders */
 	mutex_lock(&ioc->sas_topology_mutex);
@@ -3549,7 +3549,7 @@ retry_page:
 			goto redo_expander_scan;
 		}
 	}
-	mutex_lock(&ioc->sas_topology_mutex);
+	mutex_unlock(&ioc->sas_topology_mutex);
 }
 
 /**
-- 
1.6.3.2

