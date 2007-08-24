Return-Path: <linux-kernel-owner+w=401wt.eu-S1764668AbXHXSwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764668AbXHXSwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbXHXSwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:52:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60416 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbXHXSwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=lCmKkIMY10STArNdrvi4QXCj4wuRI/vgl2tcOQ+KbD0naUv/mNQ71O95Et8oRsr9NVXi/iPQMAKA6xz2RTI/KXPYXs2quyXsWxJBuIzBN+w/aCza9s+TB23RGTZ9++I6F0zckOHlQkJB2Ek6M9lzjvzfJRO+dJ5d7s+bVrZIies=
Message-ID: <46CF2849.2090008@gmail.com>
Date: Fri, 24 Aug 2007 14:49:45 -0400
From: Scott Thompson <postfailathushmail@gmail.com>
Reply-To: postfail@hushmail.com
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       jirislaby@gmail.com
Subject: [PATCH] /drivers/char sx.c ioremap -> pci_ioremap api
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


patchset against 2.6.23-rc3.

moves the iomap/iounmap call to pci 'flavor'.  this was a
recommendation from a previously submitted patch that handles
the unchecked iomap (or, now, pci_iomap) return code.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------

diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 85a2328..481334f 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2626,14 +2626,14 @@ static void __devinit fix_sx_pci(struct pci_dev *pdev, struct sx_board *board)

  	pci_read_config_dword(pdev, PCI_BASE_ADDRESS_0, &hwbase);
  	hwbase &= PCI_BASE_ADDRESS_MEM_MASK;
-	rebase = ioremap(hwbase, 0x80);
+	rebase = pci_iomap(pdev, 0, 0x80);
  	t = readl(rebase + CNTRL_REG_OFFSET);
  	if (t != CNTRL_REG_GOODVALUE) {
  		printk(KERN_DEBUG "sx: performing cntrl reg fix: %08x -> "
  			"%08x\n", t, CNTRL_REG_GOODVALUE);
  		writel(CNTRL_REG_GOODVALUE, rebase + CNTRL_REG_OFFSET);
  	}
-	iounmap(rebase);
+	pci_iounmap(pdev, rebase);
  }
  #endif
