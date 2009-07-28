Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZG1WGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZG1WGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZG1WGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:06:18 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33429 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZG1WGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=m5tgmnQmRcvB49o/rz36UFzpkN0Bb01aPP91qjOSlYgg3HnQDhGoGtKO/oTqd/N96S
         msLThIvAqY/2zf4/uJQNq4oGDTD3yOz7oVayLYq6wPHqiV8/Dqwb0RobnIpPW381gIYb
         sElwT7WtAY8eqtvVDEsYrouxhAdSNbQ2asulg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] mce: fix "mce" boot option handling for CONFIG_X86_NEW_MCE
Date: Tue, 28 Jul 2009 23:55:09 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090728-04869-gdae50fe-dirty; KDE/4.2.4; i686; ; )
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907282355.10073.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] mce: fix "mce" boot option handling for CONFIG_X86_NEW_MCE

"mce argument mce ignored. Please use /sys" message shouldn't
be printed when using "mce" boot option.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1542,8 +1542,10 @@ static struct miscdevice mce_log_device 
  */
 static int __init mcheck_enable(char *str)
 {
-	if (*str == 0)
+	if (*str == 0) {
 		enable_p5_mce();
+		return 1;
+	}
 	if (*str == '=')
 		str++;
 	if (!strcmp(str, "off"))
