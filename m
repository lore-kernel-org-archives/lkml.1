Return-Path: <linux-kernel-owner+w=401wt.eu-S1763045AbYBNSiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763045AbYBNSiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYBNSiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:38:03 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:40004 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbYBNSiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:38:02 -0500
Date: Thu, 14 Feb 2008 12:26:38 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 1/4] IPMI: Change barrier to cpu_relax in poweroff code
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080214182638.GA20148@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Change a barrier to cpu_relax(), which is more appropriate for a
polling loop.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6.24/drivers/char/ipmi/ipmi_poweroff.c
===================================================================
--- linux-2.6.24.orig/drivers/char/ipmi/ipmi_poweroff.c
+++ linux-2.6.24/drivers/char/ipmi/ipmi_poweroff.c
@@ -175,7 +175,7 @@ static int ipmi_request_in_rc_mode(ipmi_
 	 */
 	while (atomic_read(&dummy_count) > 0) {
 		ipmi_poll_interface(user);
-		barrier();
+		cpu_relax();
 	}
 
 	return halt_recv_msg.msg.data[0];
