Return-Path: <linux-kernel-owner+w=401wt.eu-S1764270AbYBNSic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764270AbYBNSic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbYBNSiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:38:05 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:40004 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbYBNSiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:38:03 -0500
Date: Thu, 14 Feb 2008 12:28:17 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 2/4] IPMI: Remove unnecessary memory barriers
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080214182817.GB20148@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Remove some unnecessary barriers.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
This can be folded into ipmi-dont-grab-locks-in-run-to-completion-mode.patch

Index: linux-2.6.24/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.24.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6.24/drivers/char/ipmi/ipmi_msghandler.c
@@ -3518,7 +3518,6 @@ void ipmi_smi_msg_received(ipmi_smi_t   
 	/* To preserve message order, if the list is not empty, we
            tack this message onto the end of the list. */
 	run_to_completion = intf->run_to_completion;
-	barrier();
 	if (!run_to_completion)
 		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
 	if (!list_empty(&intf->waiting_msgs)) {
@@ -3535,7 +3534,6 @@ void ipmi_smi_msg_received(ipmi_smi_t   
 		/* Could not handle the message now, just add it to a
                    list to handle later. */
 		run_to_completion = intf->run_to_completion;
-		barrier();
 		if (!run_to_completion)
 			spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
 		list_add_tail(&msg->link, &intf->waiting_msgs);
