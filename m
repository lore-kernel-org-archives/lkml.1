Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbYDBPoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbYDBPoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYDBPoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:44:08 -0400
Received: from rtr.ca ([76.10.145.34]:1099 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbYDBPoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:44:07 -0400
Message-ID: <47F3A9C3.7030702@rtr.ca>
Date: Wed, 02 Apr 2008 11:44:03 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@suse.cz>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, jikos@suse.cz,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.25-rc7:  Ugh. ---> PATCH
References: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch seems to fix it.
Could you guys look this over some more,
as I really am not familiar with the USB code.

* * * *

When comparing 2.6.24 against 2.6.25, this line of code
stood out as not looking entirely correct, given the new
uses of QH_STATE_UNLINK_WAIT in 2.6.25.

Applying this patch seems to fix the USB suspend/resume deaths
on my machine here.  More testing is needed to be sure.

Signed-off-by: Mark Lord <mlord@pobox.com>


--- linux-2.6.25-rc8/drivers/usb/host/ehci-hcd.c	2008-03-11 11:18:40.000000000 -0400
+++ linux/drivers/usb/host/ehci-hcd.c	2008-04-02 11:36:13.000000000 -0400
@@ -815,7 +815,7 @@
 		end_unlink_async(ehci);
 
 	/* if it's not linked then there's nothing to do */
-	if (qh->qh_state != QH_STATE_LINKED)
+	if (qh->qh_state != QH_STATE_LINKED && qh->qh_state != QH_STATE_UNLINK_WAIT)
 		;
 
 	/* defer till later if busy */
