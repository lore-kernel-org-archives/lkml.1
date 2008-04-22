Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbYDVW25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbYDVW25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758490AbYDVW2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:28:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:53859 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370AbYDVW2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=s7qSxJ4195Y2CKG/9xTj2SM/XtU4jqvQA/Co2S96ZJZnDmQz2YDaNfQ9eF+wc0YS6bGGsvtNV8mMW4s6hrUjlNpxgXMm+kHDHTcemwEr1T4CB5/lrfYagdwOFjq8ySn6t7uF+4IBAEZRtw5emw9HDoh6fzssG55sLMbvXycW8y0=
Date: Wed, 23 Apr 2008 00:28:47 +0200 (CEST)
To: Shaohua Li <shaohua.li@intel.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] PCI Express ASPM support should default to 'No'
Message-ID: <alpine.LNX.1.00.0804230024210.14359@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running 'make oldconfig' I just noticed that PCIEASPM defaults to 
'y' in Kconfig even though the feature is both experimental and the 
help text recommends that if you are unsure you say 'n'.
It seems to me that this really should default to 'n', not 'y' at the 
moment.
The following patch makes that change. Please consider applying.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index 25b04fb..5a0c6ad 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -33,7 +33,7 @@ source "drivers/pci/pcie/aer/Kconfig"
 config PCIEASPM
 	bool "PCI Express ASPM support(Experimental)"
 	depends on PCI && EXPERIMENTAL && PCIEPORTBUS
-	default y
+	default n
 	help
 	  This enables PCI Express ASPM (Active State Power Management) and
 	  Clock Power Management. ASPM supports state L0/L0s/L1.


