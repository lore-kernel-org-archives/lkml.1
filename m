Return-Path: <linux-kernel-owner+w=401wt.eu-S1764774AbXLPCT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764774AbXLPCT5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 21:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXLPCTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 21:19:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:50650 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbXLPCTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 21:19:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=cdHmf+P3AusVcOVgufIy+hLLQQUY9Is6zv7Mf3GNrDVD4csuwVkoniLTff3hePOzF2uvg33JhL0xptIZyZj2QhDe7Q7y28OlEilRwC1fLOBe4Im4BgsEtLNVN4co3Hs4MrKuzhIPDSXRrz4W0TskTV8PP7k9vy6OCOFg6vndVbE=
Date: Sun, 16 Dec 2007 03:21:29 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH RESEND] usb/storage/initializers.c: fix signedness
	difference
Message-ID: <20071216022125.GH26986@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix warnings:
drivers/usb/storage/initializers.c:83:26: warning: incorrect type in argument 5 (different signedness)
drivers/usb/storage/initializers.c:83:26:    expected unsigned int *act_len
drivers/usb/storage/initializers.c:83:26:    got int *<noident>
drivers/usb/storage/initializers.c:89:26: warning: incorrect type in argument 5 (different signedness)
drivers/usb/storage/initializers.c:89:26:    expected unsigned int *act_len
drivers/usb/storage/initializers.c:89:26:    got int *<noident>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/storage/initializers.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
index ee5b42a..187dd1e 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -66,7 +66,8 @@ int usb_stor_ucr61s2b_init(struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap*) us->iobuf;
 	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap*) us->iobuf;
-	int res, partial;
+	int res;
+	unsigned int partial;
 	static char init_string[] = "\xec\x0a\x06\x00$PCCHIPS";

 	US_DEBUGP("Sending UCR-61S2B initialization packet...\n");
--
1.5.3.4

