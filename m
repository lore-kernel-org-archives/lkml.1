Return-Path: <linux-kernel-owner+w=401wt.eu-S1030761AbXBOT2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761AbXBOT2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030760AbXBOT2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:28:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:19836 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030757AbXBOT1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:27:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=iko0vkTGPGy9R5gr9I3PZ0wuyeshaf22v02f+R/Fpd9JNCi/D8ZI52KWzmj2mZblu5oT3IR0FqCHNIy3uO/tlokLkIjbuAIhSx56yQmfa8f000MqlSizP9dMhTgy0eOEiN7IEEmkUuak4Upoe+hrjLnN7Jffs5TobCLiYkj0n8E=
Date: Thu, 15 Feb 2007 22:25:13 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Helge Deller <deller@gmx.de>
Cc: Andrew Morton <akpm@osdl.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: [PATCH] HIL: fix improper call of release_region v2
Message-ID: <20070215192513.GA12857@cvg>
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

An improved version (v2). Helge, please check it and Ack then.

 drivers/input/keyboard/hilkbd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
index 255a6ec..4de4dc2 100644
--- a/drivers/input/keyboard/hilkbd.c
+++ b/drivers/input/keyboard/hilkbd.c
@@ -294,8 +294,10 @@ err3:
 	disable_irq(HIL_IRQ);
 	free_irq(HIL_IRQ, hil_dev.dev_id);
 err2:
+#if defined(CONFIG_HP300)
 	release_region(HILBASE + HIL_DATA, 2);
 err1:
+#endif
 	input_free_device(hil_dev.dev);
 	hil_dev.dev = NULL;
 	return err;
