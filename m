Return-Path: <linux-kernel-owner+w=401wt.eu-S968666AbXFHLTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968666AbXFHLTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967593AbXFHLSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:18:53 -0400
Received: from canuck.infradead.org ([209.217.80.40]:45513 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966579AbXFHLSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:18:52 -0400
Subject: [PATCH] PowerPC: Enable arbitary speed tty ioctls and split
	input/output speed
From: David Woodhouse <dwmw2@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1181133185.4096.32.camel@pmac.infradead.org>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
	 <18010.24300.599531.828815@cargo.ozlabs.ibm.com>
	 <1181133185.4096.32.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 12:18:46 +0100
Message-Id: <1181301526.2801.31.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the defines/macros activates the existing code in the tty layer
and allows this platform to use the arbitary speed ioctl setting layer

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/include/asm-powerpc/termbits.h b/include/asm-powerpc/termbits.h
index 5e79198..6698188 100644
--- a/include/asm-powerpc/termbits.h
+++ b/include/asm-powerpc/termbits.h
@@ -152,6 +152,10 @@ struct ktermios {
 #define B3000000  00034
 #define B3500000  00035
 #define B4000000  00036
+#define   BOTHER  00037
+
+#define CIBAUD	077600000
+#define IBSHIFT	16		/* Shift from CBAUD to CIBAUD */
 
 #define CSIZE	00001400
 #define   CS5	00000000

-- 
dwmw2

