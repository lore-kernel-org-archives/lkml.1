Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbYCGDIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbYCGDIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 22:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbYCGDIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 22:08:30 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:6382 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbYCGDI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 22:08:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JbzvQrwcbG0F90pCJMfVjoBe9XuYqDjdyEvDqY+Re/Q11rDHwcXhTQKoMO/RMH+xNYdYVBVHPvsDEdBg8mV7QS3vf6YNC4sTgIsR4TUAQmPm/HpMeDos825uL3+KhECf6rfxfB1VrfGMOGqHP7yA2mTSqO+ViNxe5INio0K9jxk=
Message-ID: <47D0B1A4.2040104@gmail.com>
Date: Fri, 07 Mar 2008 12:08:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Mark Lord <liml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 1/2] scsi: export scsi_forget_host()
References: <20080222200951.GI16995@parisc-linux.org>	 <47BF3E54.9050609@rtr.ca>  <47CFA9A6.2040506@gmail.com>	 <1204817301.3062.3.camel@localhost.localdomain>	 <47D08478.8010700@gmail.com>	 <1204848119.3062.94.camel@localhost.localdomain>	 <47D08892.3080209@gmail.com>	 <1204849353.3062.107.camel@localhost.localdomain>	 <47D08C32.8060907@gmail.com> <1204850398.3062.111.camel@localhost.localdomain> <47D08FAA.7070001@gmail.com>
In-Reply-To: <47D08FAA.7070001@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export scsi_forget_host(), will be used by libata.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_priv.h |    1 -
 drivers/scsi/scsi_scan.c |    1 +
 include/scsi/scsi_host.h |    1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

Index: work1/drivers/scsi/scsi_priv.h
===================================================================
--- work1.orig/drivers/scsi/scsi_priv.h
+++ work1/drivers/scsi/scsi_priv.h
@@ -98,7 +98,6 @@ extern void scsi_exit_procfs(void);
 /* scsi_scan.c */
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, unsigned int, int);
-extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
 
 /* scsi_sysctl.c */
Index: work1/drivers/scsi/scsi_scan.c
===================================================================
--- work1.orig/drivers/scsi/scsi_scan.c
+++ work1/drivers/scsi/scsi_scan.c
@@ -1845,6 +1845,7 @@ void scsi_forget_host(struct Scsi_Host *
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
+EXPORT_SYMBOL(scsi_forget_host);
 
 /*
  * Function:    scsi_get_host_dev()
Index: work1/include/scsi/scsi_host.h
===================================================================
--- work1.orig/include/scsi/scsi_host.h
+++ work1/include/scsi/scsi_host.h
@@ -719,6 +719,7 @@ extern struct Scsi_Host *scsi_host_alloc
 extern int __must_check scsi_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_scan_host(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
+extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);
