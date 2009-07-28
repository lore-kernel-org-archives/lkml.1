Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbZG1SXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbZG1SXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbZG1SXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:23:12 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:28904 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbZG1SXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:23:10 -0400
Date: Tue, 28 Jul 2009 11:22:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lud <linux-usb@vger.kernel.org>, gregkh <greg@kroah.com>
Subject: [PATCH -next] usbtmc: fix printk format warnings
Message-Id: <20090728112241.b32a684b.randy.dunlap@oracle.com>
In-Reply-To: <20090728174224.647cc3ba.sfr@canb.auug.org.au>
References: <20090728174224.647cc3ba.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A6F4207.00CF:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:
drivers/usb/class/usbtmc.c:466: warning: format '%zu' expects type 'size_t', but argument 4 has type 'u32'
drivers/usb/class/usbtmc.c:466: warning: format '%zu' expects type 'size_t', but argument 5 has type 'int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/class/usbtmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090728.orig/drivers/usb/class/usbtmc.c
+++ linux-next-20090728/drivers/usb/class/usbtmc.c
@@ -463,7 +463,7 @@ static ssize_t usbtmc_read(struct file *
 
 		/* Ensure the instrument doesn't lie about it */
 		if(n_characters > actual - 12) {
-			dev_err(dev, "Device lies about message size: %zu > %zu\n", n_characters, actual - 12);
+			dev_err(dev, "Device lies about message size: %u > %d\n", n_characters, actual - 12);
 			n_characters = actual - 12;
 		}
 



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
