Return-Path: <linux-kernel-owner+w=401wt.eu-S1030371AbXBORxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030371AbXBORxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030382AbXBORxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:53:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:28067 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030371AbXBORxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:53:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=FzjpmdoeKWxKjprf9Bm/NgT/+BzOyDXi8DiZ0fg/diHONJ1pMmvl1gKbO4cfaDvnxuDB4m9/Y0a8Lha6fmeIPAsPAnvv+V0NASTn8SKDvf5SuzAyMdiL/fTr9TFMAJQ/UKd6ELwpmAAlN7oSSjbEtq2T47WJr5prqLs08nMCauY=
Date: Thu, 15 Feb 2007 20:50:31 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] HIL: fix improper call of release_region
Message-ID: <20070215175031.GA12012@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thist patch prevents from improper call of release_region
if the code has been compiled without CONFIG_HP300 support.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>

---

 drivers/input/keyboard/hilkbd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
index 255a6ec..c3c0da3 100644
--- a/drivers/input/keyboard/hilkbd.c
+++ b/drivers/input/keyboard/hilkbd.c
@@ -294,7 +294,9 @@ err3:
 	disable_irq(HIL_IRQ);
 	free_irq(HIL_IRQ, hil_dev.dev_id);
 err2:
+#if defined(CONFIG_HP300)
 	release_region(HILBASE + HIL_DATA, 2);
+#endif
 err1:
 	input_free_device(hil_dev.dev);
 	hil_dev.dev = NULL;
