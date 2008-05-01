Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbYEAMDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbYEAMDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbYEAMDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:03:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:25338 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242AbYEAMDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:03:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=L9P0+lw95xADYp9LKl/LdCA+2z+LPhZMkIOQ/pAFEVw4SscDcA8qMoiuOOKzWUTMhB14dMvT+0I6iRV/kP5Wnc4v1XpP7kPros02dxyvb4TJ/ptbZ6rmE3uC4PJyFfBCwbZs0FZLUAHU16mwf3bXX9eDo8itsjknM9QUzqn0WzM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Thu, 1 May 2008 14:18:38 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011418.39999.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Regression fix for some host drivers using MMIO, i.e. siimage
(big thanks to Jeremy Kerr for the detailed bug analysis).


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-probe.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


Bartlomiej Zolnierkiewicz (1):
      ide: fix early setup of hwif->host_flags


diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 099a0fe..591deda 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1347,7 +1347,8 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 	    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS))
 		hwif->irq = port ? 15 : 14;
 
-	hwif->host_flags = d->host_flags;
+	/* ->host_flags may be set by ->init_iops (or even earlier...) */
+	hwif->host_flags |= d->host_flags;
 	hwif->pio_mask = d->pio_mask;
 
 	/* ->set_pio_mode for DTC2278 is currently limited to port 0 */
