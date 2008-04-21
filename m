Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbYDUThR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbYDUThR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYDUThE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:37:04 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:34575 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYDUThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:37:03 -0400
Date: Mon, 21 Apr 2008 14:36:39 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 3/3] IPMI: fix return from atca_oem_poweroff_hook
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080421193638.GC13900@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A void returning function returned the return value of another void 
returning function...

Spotted by sparse.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Corey Minyard <cminyard@mvista.com>

Index: linux-2.6.24/drivers/char/ipmi/ipmi_poweroff.c
===================================================================
--- linux-2.6.24.orig/drivers/char/ipmi/ipmi_poweroff.c
+++ linux-2.6.24/drivers/char/ipmi/ipmi_poweroff.c
@@ -308,7 +308,7 @@ static void ipmi_poweroff_atca(ipmi_user
 	}
 
 	if (atca_oem_poweroff_hook)
-		return atca_oem_poweroff_hook(user);
+		atca_oem_poweroff_hook(user);
  out:
 	return;
 }
