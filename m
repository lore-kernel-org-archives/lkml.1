Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbZG1WGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbZG1WGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZG1WGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:06:16 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56675 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbZG1WGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=jGXByd+b1wPoyx8A4nTg5LnvRSUXYjMJNIbCo3Mnj4kADyVMk7pE0HnseOmALT1sHy
         3+tvJQf2u6F/dQgweZou8pheK3RlM71r7NaCXi7Bv8QOTD64mYzFF9NxzhcnlXSsD/ur
         /Jywri9EFX0t0Y1SnGYjeGQiV2l7/Eljyy1XY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] mce: remove never executed code
Date: Tue, 28 Jul 2009 23:56:37 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090728-04869-gdae50fe-dirty; KDE/4.2.4; i686; ; )
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907282356.37402.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] mce: remove never executed code

fseverities_coverage is never NULL in err_out code path.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/arch/x86/kernel/cpu/mcheck/mce-severity.c
===================================================================
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -209,8 +209,6 @@ static int __init severities_debugfs_ini
 	return 0;
 
 err_out:
-	if (fseverities_coverage)
-		debugfs_remove(fseverities_coverage);
 	if (dmce)
 		debugfs_remove(dmce);
 	return -ENOMEM;
