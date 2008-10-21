Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbYJURH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbYJURH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYJURHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:07:17 -0400
Received: from outbound-mail-152.bluehost.com ([67.222.39.32]:49740 "HELO
	outbound-mail-152.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750930AbYJURHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:07:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=OSodSAffq1AYhDuTMivsjI14BQQh7McRMIl4LErUjhlyYYS3DsygVrrobaHBn537ErY2W1iWf8G2WijDM0FP19cKLrNzqqbNozbIAGgpGWwfGUkUJ1QodN4LGxun1P/0;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] include io.h in pci.h to avoid pci_ioremap build errors
Date: Tue, 21 Oct 2008 10:07:14 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810211007.14378.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo pointed out that the m32r build was broken by pci_ioremap.  It looks like 
some files include pci.h w/o including io.h.  The latter defines ioremap_* if 
present, so it makes sense to include it in pci.h now that we have pci_ioremap 
there.

I'll queue this up in my tree for the next pull request, but affected users 
can apply this patch in the meantime.

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 085187b..3e2f1d3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -18,6 +18,7 @@
 #define LINUX_PCI_H
 
 #include <linux/pci_regs.h>	/* The pci register defines */
+#include <asm/io.h>
 
 /*
  * The PCI interface treats multi-function devices as independent

