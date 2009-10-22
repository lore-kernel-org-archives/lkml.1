Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZJVNy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZJVNy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbZJVNy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:54:57 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:25376 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755831AbZJVNy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:54:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0EAIoB4ErCTtAn/2dsb2JhbACBUtoHhD8E
Date: Thu, 22 Oct 2009 15:54:54 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [PATCH] m68k allow ioremapping top of memory
Message-ID: <20091022135454.GA27903@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The test in __ioremap to reject memory ranges crossing the 0 boundary
rejects also memory ranges at the end of the memory.  Fix that.

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
