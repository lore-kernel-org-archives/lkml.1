Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbXKTNpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbXKTNpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 08:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbXKTNpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 08:45:30 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:59752 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbXKTNp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 08:45:29 -0500
Date: Tue, 20 Nov 2007 07:45:17 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH] ipmi: add the standard watchdog timeout ioctls
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: =?iso-8859-1?Q?Beno=EEt?= Guillon <guillon@thalescomputers.fr>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20071120134517.GA6205@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Add the standard IOCTLs to the IPMI driver for setting and getting
the pretimeout.  Tested by Benoît Guillon.

Signed off by: Corey Minyard <cminyard@mvista.com>
Cc: Benoît Guillon <guillon@thalescomputers.fr>
---
Index: linux-2.6.23/drivers/char/ipmi/ipmi_watchdog.c
===================================================================
--- linux-2.6.23.orig/drivers/char/ipmi/ipmi_watchdog.c
+++ linux-2.6.23/drivers/char/ipmi/ipmi_watchdog.c
@@ -683,6 +683,7 @@ static int ipmi_ioctl(struct inode *inod
 		return 0;
 
 	case WDIOC_SET_PRETIMEOUT:
+	case WDIOC_SETPRETIMEOUT:
 		i = copy_from_user(&val, argp, sizeof(int));
 		if (i)
 			return -EFAULT;
@@ -690,6 +691,7 @@ static int ipmi_ioctl(struct inode *inod
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 
 	case WDIOC_GET_PRETIMEOUT:
+	case WDIOC_GETPRETIMEOUT:
 		i = copy_to_user(argp, &pretimeout, sizeof(pretimeout));
 		if (i)
 			return -EFAULT;
