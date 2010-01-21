Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790Ab0AUAS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0AUAS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670Ab0AUAS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:18:57 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:43938 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab0AUAS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:18:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PFbrI0v8FJmtKUCKWFSWH1ntwxxQT+F7vAGW/eS8To2w0wxcuM4YGxrQWP3pXKKbQc
         Hmx32xQ21h3QjKvPOKYJWIoGhD5sUGQF/5zg05W8aWz6+kN3LOU9vYVS/PBw204QPqzK
         1F7x0a30HgAkaQxWZ3ru4DhxZZvHulwiLbvcU=
Message-ID: <4B579C4A.3040907@gmail.com>
Date: Thu, 21 Jan 2010 09:14:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: [PATCH #upstream-fixes] libata-sff: remove CONFIG_NO_ATA_LEGACY
References: <20100120142943.GE3580@faui49.informatik.uni-erlangen.de>
In-Reply-To: <20100120142943.GE3580@faui49.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_NO_ATA_LEGACY isn't used by anyone.  Drop it.

Reported-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
On 01/20/2010 11:29 PM, Christoph Egger wrote:
> 	That's the only place where it is checked for
> NO_ATA_LEGACY. As this Item does appear nowhere in KConfig and
> therefor is not selectable I'm wondering whether that small Code
> fragment should be dropped or a new KConfig option should be added?
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.

It's supposed to be set by architecture code to prevent SFF controller
attach if it's in legacy mode.  There apparently is no user left.
Trying to find the last user... it seems it hasn't been unused for at
least two year.  I guess it can be removed then.

Thanks!

 drivers/ata/libata-sff.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 741065c..b9df435 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2945,15 +2945,6 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 		mask = (1 << 2) | (1 << 0);
 		if ((tmp8 & mask) != mask)
 			legacy_mode = 1;
-#if defined(CONFIG_NO_ATA_LEGACY)
-		/* Some platforms with PCI limits cannot address compat
-		   port space. In that case we punt if their firmware has
-		   left a device in compatibility mode */
-		if (legacy_mode) {
-			printk(KERN_ERR "ata: Compatibility mode ATA is not supported on this platform, skipping.\n");
-			return -EOPNOTSUPP;
-		}
-#endif
 	}
 
 	if (!devres_open_group(dev, NULL, GFP_KERNEL))
