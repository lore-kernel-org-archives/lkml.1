Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945Ab0AGTui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0AGTui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937Ab0AGTui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:50:38 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:55866 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738Ab0AGTuh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:50:37 -0500
X-Greylist: delayed 1154 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 14:50:37 EST
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: Roel Kluin <roel.kluin@gmail.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Date: Thu, 7 Jan 2010 12:31:02 -0700
Subject: RE: [PATCH] mpt2sas: Fix &&/|| confusion in
 _scsih_sas_device_status_change_event()
Thread-Topic: [PATCH] mpt2sas: Fix &&/|| confusion in
 _scsih_sas_device_status_change_event()
Thread-Index: AcqJcPlGGyfLLrp5TteTFnHNmMNwxwGXefcw
Message-ID: <4565AEA676113A449269C2F3A549520F04463B74@cosmail03.lsi.com>
References: <4B3B86CC.5010205@gmail.com>
In-Reply-To: <4B3B86CC.5010205@gmail.com>
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

nack

The code beyond this check is intended for either INTERNAL_DEVICE_RESET or CMP_DEVICE_RESET.   If the reason code is something else, we will want to return.  There are 10 other types of reason codes besides these two. This proposed patch means we return only when the reason code is either INTERNAL_DEVICE_RESET or CMP_INTERNAL_RESET. 

Eric Moore

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Roel Kluin
Sent: Wednesday, December 30, 2009 9:59 AM
To: James E.J. Bottomley; linux-scsi@vger.kernel.org; Andrew Morton; LKML; Desai, Kashyap
Subject: [PATCH] mpt2sas: Fix &&/|| confusion in _scsih_sas_device_status_change_event()

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
