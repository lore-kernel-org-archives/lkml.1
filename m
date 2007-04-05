Return-Path: <linux-kernel-owner+w=401wt.eu-S1767399AbXDEWx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767399AbXDEWx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767400AbXDEWx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:53:28 -0400
Received: from smtp-out.google.com ([216.239.45.13]:26730 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767399AbXDEWx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:53:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type;
	b=nN+NAh3jz+vorURb5xEDh5iHhYaN9gtFpCDSZvYVS1tcgPPwy8USdKpdQf/PoQIOD
	8CvIpPxJD0m2xPR/zvlzw==
Message-ID: <46157DD2.4050502@google.com>
Date: Thu, 05 Apr 2007 15:53:06 -0700
From: Martin Bligh <mbligh@google.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] leave loglevel at 7 through sysrq output so you can actually
 read it
Content-Type: multipart/mixed;
 boundary="------------070806010306070301030905"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070806010306070301030905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

We carefully set loglevel to 7, and print the sysrq messsage
as to what event we're doing, but we can't actually see
the output as it sets it back before calling the handler,
rather than after.

Move the assignment down one line.

Signed-off-by: Martin J. Bligh <mbligh@google.com>

--------------070806010306070301030905
Content-Type: text/plain;
 name="linux-2.6.21-rc5-git10-loglevel"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.21-rc5-git10-loglevel"

diff -aurpN -X /home/mbligh/.diff.exclude linux-2.6.21-rc5-git10/drivers/char/sysrq.c linux-2.6.21-rc5-git10-loglevel/drivers/char/sysrq.c
--- linux-2.6.21-rc5-git10/drivers/char/sysrq.c	2007-04-03 11:23:54.000000000 -0700
+++ linux-2.6.21-rc5-git10-loglevel/drivers/char/sysrq.c	2007-04-05 15:49:40.000000000 -0700
@@ -421,8 +421,8 @@ void __handle_sysrq(int key, struct tty_
 		 */
 		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
 			printk("%s\n", op_p->action_msg);
-			console_loglevel = orig_log_level;
 			op_p->handler(key, tty);
+			console_loglevel = orig_log_level;
 		} else {
 			printk("This sysrq operation is disabled.\n");
 		}

--------------070806010306070301030905--
