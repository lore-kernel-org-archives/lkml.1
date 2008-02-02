Return-Path: <linux-kernel-owner+w=401wt.eu-S1764774AbYBBF2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764774AbYBBF2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 00:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760548AbYBBF2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 00:28:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54297 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759793AbYBBF2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 00:28:20 -0500
Message-ID: <47A3FF3F.1040908@cn.fujitsu.com>
Date: Sat, 02 Feb 2008 13:27:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: romieu@fr.zoreil.com
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jgarzik@pobox.com
Subject: [PATCH] sis190: fix compile error section type conflict
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following compile error:

drivers/net/sis190.c:329: error: sis190_pci_tbl causes a section type conflict
make[2]: *** [drivers/net/sis190.o] Error 1
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/net/sis190.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sis190.c b/drivers/net/sis190.c
index b570402..e48e4ad 100644
--- a/drivers/net/sis190.c
+++ b/drivers/net/sis190.c
@@ -326,7 +326,7 @@ static const struct {
 	{ "SiS 191 PCI Gigabit Ethernet adapter" },
 };
 
-static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
+static const struct pci_device_id sis190_pci_tbl[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
 	{ 0, },
-- 
1.5.4.rc3


