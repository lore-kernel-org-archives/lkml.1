Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZEYVlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZEYVlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZEYVlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:41:08 -0400
Received: from smtpout10.uol.com.br ([200.221.4.201]:41253 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519AbZEYVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:41:06 -0400
Date: Mon, 25 May 2009 18:41:04 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Phil Dibowitz <phil@ipom.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Robert Hancock <hancockrwd@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] usb-storage: include USB drive in unusual_devs list
Message-ID: <20090525214104.GA14942@ime.usp.br>
References: <20090525151313.GA2246@ime.usp.br> <Pine.LNX.4.44L0.0905251657100.27717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0905251657100.27717-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: 292c60fa826f469ec87ff509a8d08fd3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 25 2009, Alan Stern wrote:
> This looks good.  Make those suggested changes and submit it to Phil 
> Dibowitz <phil@ipom.com>; it might even get merged in time to appear 
> in 2.6.30.

Thanks, Alan. Here it goes:

This patch adds a quirk entry for the Leading Driver UD-11 usb flash
drive.

As Alan Stern told me, the device doesn't deal correctly with the
locking media feature of the device, and this patch incorporates it.

Compiled, tested, working.


Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

---

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -838,6 +838,13 @@ UNUSUAL_DEV( 0x066f, 0x8000, 0x0001, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Rogerio Brito <rbrito@ime.usp.br> */
+UNUSUAL_DEV( 0x067b, 0x2317, 0x0001, 0x001,
+		"Prolific Technology, Inc.",
+		"Mass Storage Device",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_NOT_LOCKABLE ),
+
 /* Reported by Richard -=[]=- <micro_flyer@hotmail.com> */
 /* Change to bcdDeviceMin (0x0100 to 0x0001) reported by
  * Thomas Bartosik <tbartdev@gmx-topmail.de> */

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
