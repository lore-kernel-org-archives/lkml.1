Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYJNQ2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYJNQ2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYJNQ16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 12:27:58 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:36190 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYJNQ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 12:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:sender;
        b=tJtSbcRKfPFmJr82qwVegCLkFimfPb2Ed9EhwETYg/9Ww9dHPXZXRqqG8SmEF+GKNr
         eWlttAa/2bfAEBryyQthOaxt/spDPVm4dwZsWUs4VHKqgbVjrY47Lu7DivJLimI47BkJ
         rJLOlBcL1IyJ/lJ8U0Z2GcyEhPRZX1XTnXLd8=
Date: Tue, 14 Oct 2008 12:26:21 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: davem@davemloft.net, alan@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] serial: Make uart_port's ioport "resource_size_t"
Message-ID: <20081014162621.GA18166@yoda.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently uart_port's iobase was changed to be an 'unsigned
long' to avoid chopping off the upper 32-bits of the
address on 64-bit CPUs.  However, there are CPUs that are
32-bit but have a 64-bit address space.  This changes
iobase to be 'resource_size_t' to accommodate those types
of systems.  This also matches what is done for the mapbase
member of uart_port.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

---

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index e27f216..cb0185b 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -241,7 +241,7 @@ typedef unsigned int __bitwise__ upf_t;
 
 struct uart_port {
 	spinlock_t		lock;			/* port lock */
-	unsigned long		iobase;			/* in/out[bwl] */
+	resource_size_t		iobase;			/* in/out[bwl] */
 	unsigned char __iomem	*membase;		/* read/write[bwl] */
 	unsigned int		irq;			/* irq number */
 	unsigned int		uartclk;		/* base uart clock */
