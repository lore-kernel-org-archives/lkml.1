Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbYEWQKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbYEWQKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYEWQKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:10:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49442 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbYEWQKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:10:21 -0400
Date: Fri, 23 May 2008 17:09:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-input@vger.kernel.org
Cc: linu-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20080523160955.GA19674@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: [PATCH] Add switch for dock events
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a switch to signal dock events to userspace.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

I've done this as an input event rather than anything else since there 
isn't necessarily a terribly coherent concept of a dock device. HPs (for 
example) don't use ACPI for docking - the dock is simply an extension of 
devices that are already on the system. We can't sensibly create a dock 
platform device and then generate uevents on it. Doing it this way lets 
us standardise on a way to send docking events to userspace, which lets 
desktops do things like automatically expand onto external monitors when 
the system is docked.

diff --git a/include/linux/input.h b/include/linux/input.h
index 28a094f..0bc55ee 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -638,6 +638,7 @@ struct input_absinfo {
 #define SW_TABLET_MODE		0x01  /* set = tablet mode */
 #define SW_HEADPHONE_INSERT	0x02  /* set = inserted */
 #define SW_RADIO		0x03  /* set = radio enabled */
+#define SW_DOCK			0x04  /* set = plugged into dock */
 #define SW_MAX			0x0f
 #define SW_CNT			(SW_MAX+1)


-- 
Matthew Garrett | mjg59@srcf.ucam.org
