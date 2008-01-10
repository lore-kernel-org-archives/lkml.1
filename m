Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbYAJTor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbYAJTor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYAJToj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:44:39 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:40848 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbYAJToi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:44:38 -0500
X-Greylist: delayed 1721 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 14:44:38 EST
Message-ID: <47866EE9.80003@tiscali.nl>
Date: Thu, 10 Jan 2008 20:15:53 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linville@tuxdriver.com, lkml <linux-kernel@vger.kernel.org>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH wireless/arlan] Replace logical- by bit-and
References: <4722453E.2090801@tiscali.nl> <472248AC.7080201@tiscali.nl>
In-Reply-To: <472248AC.7080201@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Totally untested patch below from linus' git tree. The && is incorrect, right?

from drivers/net/wireless/arlan.h:390:
#define ARLAN_POWER             0x40
#define ARLAN_ACCESS            0x80

Replace logical and by bit-and

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/arlan.h b/drivers/net/wireless/arlan.h
index 3ed1df7..7b7498f 100644
--- a/drivers/net/wireless/arlan.h
+++ b/drivers/net/wireless/arlan.h
@@ -485,7 +485,7 @@ struct arlan_private {
 #define clearClearInterrupt(dev){\
    writeControlRegister(dev,readControlRegister(dev) & ~ARLAN_CLEAR_INTERRUPT);}
 #define setPowerOff(dev){\
-   writeControlRegister(dev,readControlRegister(dev) | (ARLAN_POWER && ARLAN_ACCESS));\
+   writeControlRegister(dev, readControlRegister(dev) | (ARLAN_POWER & ARLAN_ACCESS));\
    writeControlRegister(dev,readControlRegister(dev) & ~ARLAN_ACCESS);}
 #define setPowerOn(dev){\
    writeControlRegister(dev,readControlRegister(dev) & ~(ARLAN_POWER));   }

