Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZKLQlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZKLQlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZKLQlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:41:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:54164 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZKLQlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:41:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=i8suwjux/bditDqICM96QzBuY4LOW5JNQnf7FV0TTufBM6VgqnrAFXLygfPbIGvsU0
         eA6hjdD4i1Lg6k1Tei9zY4JRPDqERHUfwAwQIBKW0mUc0r8do5TxKD4N0ErqhyJeSbOo
         V7LA79i/jf0J+1Vrbz/UNA9HRcKuyerj3PF1s=
Message-ID: <4AFC3D85.6070904@gmail.com>
Date: Thu, 12 Nov 2009 17:53:25 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mISDN: fix error return in HFCmulti_init()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The returned error should stay negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index faed794..a6624ad 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5481,7 +5481,7 @@ HFCmulti_init(void)
 		if (err) {
 			printk(KERN_ERR "error registering embedded driver: "
 				"%x\n", err);
-			return -err;
+			return err;
 		}
 		HFC_cnt++;
 		printk(KERN_INFO "%d devices registered\n", HFC_cnt);
