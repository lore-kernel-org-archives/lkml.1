Return-Path: <linux-kernel-owner+w=401wt.eu-S966305AbXIBMr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966305AbXIBMr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965473AbXIBMrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:47:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45126 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965231AbXIBMrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:47:48 -0400
Date: Sun, 2 Sep 2007 18:30:56 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Hardwick <p.hardwick@option.com>
Subject: [PATCH -mm] drivers/char/nozomi.c: __devexit_p usage build fix
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709021810080.24993@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1137243832-1188738059=:24993"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1137243832-1188738059=:24993
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


A typo results in build breakage:

drivers/char/nozomi.c:2204: error: syntax error before ‘__attribute__’
make[2]: *** [drivers/char/nozomi.o] Error 1

when CONFIG_HOTPLUG=n. This was actually meant to be __devexit_p.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/char/nozomi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1/drivers/char/nozomi.c~fix	2007-09-02 16:16:59.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/char/nozomi.c	2007-09-02 16:17:07.000000000 +0530
@@ -2201,7 +2201,7 @@ static struct pci_driver nozomi_driver =
 	.name = NOZOMI_NAME,
 	.id_table = nozomi_pci_tbl,
 	.probe = nozomi_card_init,
-	.remove = __devexit(nozomi_card_exit),
+	.remove = __devexit_p(nozomi_card_exit),
 };
 
 static __init int nozomi_init(void)
--464262402-1137243832-1188738059=:24993--
