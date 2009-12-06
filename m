Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbZLFT3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbZLFT3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbZLFT3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:29:04 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:39065 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757473AbZLFT3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:29:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFACeTG0vCTtAn/2dsb2JhbACBS9NshDME
Date: Sun, 6 Dec 2009 20:28:41 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [PATCH m68k resent] allow ioremapping top of memory
Message-ID: <20091206192841.GA23088@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert and all,

The test in __ioremap to reject memory ranges crossing the 0 boundary
rejects also memory ranges ending at the end of the memory.  Fix that.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff --git a/arch/m68k/mm/kmap.c b/arch/m68k/mm/kmap.c
--- a/arch/m68k/mm/kmap.c
+++ b/arch/m68k/mm/kmap.c
@@ -116,7 +115,7 @@ void __iomem *__ioremap(unsigned long ph
 	/*
 	 * Don't allow mappings that wrap..
 	 */
-	if (!size || size > physaddr + size)
+	if (!size || physaddr > (unsigned long)(-size))
 		return NULL;
 
 #ifdef CONFIG_AMIGA

