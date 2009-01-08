Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZAHQMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZAHQMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZAHQMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:12:25 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:35745 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbZAHQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:12:25 -0500
Date: Thu, 8 Jan 2009 17:12:22 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] wimax: fix compile bug
Message-ID: <20090108161222.GC4821@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

wimax should depend on INPUT:

net/built-in.o: In function `wimax_rfkill_rm':
linux-2.6/net/wimax/op-rfkill.c:428: undefined reference to `input_unregister_device'
net/built-in.o: In function `wimax_rfkill_add':
linux-2.6/net/wimax/op-rfkill.c:370: undefined reference to `input_allocate_device'
linux-2.6/net/wimax/op-rfkill.c:384: undefined reference to `input_register_device'
linux-2.6/net/wimax/op-rfkill.c:402: undefined reference to `input_unregister_device'
linux-2.6/net/wimax/op-rfkill.c:406: undefined reference to `input_free_device'
net/built-in.o: In function `input_report_key':
linux-2.6/include/linux/input.h:1285: undefined reference to `input_event'

Cc: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 net/wimax/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/net/wimax/Kconfig
===================================================================
--- linux-2.6.orig/net/wimax/Kconfig
+++ linux-2.6/net/wimax/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig WIMAX
 	tristate "WiMAX Wireless Broadband support"
+	depends on INPUT
 	help
 
 	  Select to configure support for devices that provide
