Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZG3VWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZG3VWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZG3VWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:22:37 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45005 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZG3VWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=VFH2I8r21KfgW3h3n/L9Q32Jg39wkDI0g4QG0lM2OaPCkmxn2Z2w7uM9NYedO3e7Em
         vgvA9yhqkxquzHtTk9xd4RShNXzxwL1W6vWnGdkyAJcVbuN5gTN8V5GUQzYr86RdEVUY
         o4oGg5pTV/gMdgCYPcfma7IlRJXXG/9GO+0mw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] x86: remove superfluous NULL pointer check in destroy_irq()
Date: Thu, 30 Jul 2009 23:21:18 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090722-04415-ge5aa24a-dirty; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
       corbet@lwn.net, eteo@redhat.com, Julia Lawall <julia@diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907302321.19086.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] x86: remove superfluous NULL pointer check in destroy_irq()

This takes care of the following entry from Dan's list:

arch/x86/kernel/apic/io_apic.c +3241 destroy_irq(11) warning: variable derefenced before check 'desc'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/x86/kernel/apic/io_apic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/arch/x86/kernel/apic/io_apic.c
===================================================================
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3238,8 +3238,7 @@ void destroy_irq(unsigned int irq)
 	cfg = desc->chip_data;
 	dynamic_irq_cleanup(irq);
 	/* connect back irq_cfg */
-	if (desc)
-		desc->chip_data = cfg;
+	desc->chip_data = cfg;
 
 	free_irte(irq);
 	spin_lock_irqsave(&vector_lock, flags);
