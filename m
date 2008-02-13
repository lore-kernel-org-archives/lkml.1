Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYBMJUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYBMJUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYBMJUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:20:31 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:37961 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYBMJU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:20:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=yHXNGuAUllLNcR+PatDWjpbMTlegoBMJsPJBnuEg7kUx7NxHHRK40UkYq/ncn3mJ55eoulF5M/OfiKBHav34+M3Id4TeiGvfQboZIiFI+drCOMEpK8Tg7YK4OEdU3BQsix5DCbhPUbvwFt+GDj43Gbw7QbZ6TXirSWtGRbXRcSc=
Message-ID: <47B2B653.7020408@gmail.com>
Date: Wed, 13 Feb 2008 18:20:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: [libata-dev #upstream-fixes] pata_legacy: don't call ata_host_detach()
 after initialization failure
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080212081816.GA17820@elte.hu> <20080212071452.5c58ae6d@laptopd505.fenrus.org> <20080213090159.GA21614@elte.hu>
In-Reply-To: <20080213090159.GA21614@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ata_host_detach() detaches an attached port and shouldn't be called on
a port which hasn't been attached yet.  pata_legacy incorrectly calls
ata_host_detach() on unattached port after initialization failure
causing oops.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
---
 drivers/ata/pata_legacy.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 333dc15..7383f19 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -1278,8 +1278,6 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 		}
 	}
 fail:
-	if (host)
-		ata_host_detach(host);
 	platform_device_unregister(pdev);
 	return ret;
 }
