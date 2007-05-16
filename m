Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbXEPLR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbXEPLR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXEPLRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:17:22 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:56863 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXEPLRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:17:21 -0400
Date: Wed, 16 May 2007 13:17:20 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/19] scsi: convert to using sg helpers
Message-ID: <20070516131720.4f9ed32a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11793043541476-git-send-email-jens.axboe@oracle.com>
References: <11793043533744-git-send-email-jens.axboe@oracle.com>
	<11793043541476-git-send-email-jens.axboe@oracle.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 10:32:19 +0200,
Jens Axboe <jens.axboe@oracle.com> wrote:

> This converts the SCSI mid layer to using the sg helpers for looking up
> sg elements, instead of doing it manually.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/scsi/scsi_lib.c |   20 +++++++++++---------
>  1 files changed, 11 insertions(+), 9 deletions(-)

This needs to include linux/scatterlist.h (other architectures seem to
pull this header in via other routes, but e.g. s390 doesn't).

---
 drivers/scsi/scsi_lib.c |    1 +
 1 files changed, 1 insertion(+)

--- linux.orig/drivers/scsi/scsi_lib.c
+++ linux/drivers/scsi/scsi_lib.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/hardirq.h>
+#include <linux/scatterlist.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
