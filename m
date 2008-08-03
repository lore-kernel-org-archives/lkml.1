Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYHCQux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYHCQux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 12:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbYHCQup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 12:50:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:34670 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbYHCQuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 12:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Z82aCn49ZSz5ZRGBHRWWZCdL7nudV834pf7QUJTuoY+fbeMw85+lN+eCyztl/nuXSm
         4nOPkzTvNe55xlLuJKy+WNAQzFpXvMxqb05zya+M1P5hwksIRSPsx6XH4EeOl4cj6psk
         TsKyq1abdrN36Stj0nDGcxAfEzBjZQgyAVx4I=
Date: Sun, 3 Aug 2008 18:50:14 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] usb: cdc-acm: flags passed to spin_lock_irqsave must be
	unsigned
Message-ID: <20080803165011.GB5414@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc warned about it:
drivers/usb/class/cdc-acm.c: In function 'acm_waker':
drivers/usb/class/cdc-acm.c:527: warning: comparison of distinct pointer types lacks a cast
drivers/usb/class/cdc-acm.c:529: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 0725b18..a92395b 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -512,7 +512,7 @@ static void acm_softint(struct work_struct *work)
 static void acm_waker(struct work_struct *waker)
 {
 	struct acm *acm = container_of(waker, struct acm, waker);
-	long flags;
+	unsigned long flags;
 	int rv;
 
 	rv = usb_autopm_get_interface(acm->control);
-- 
1.5.4.5

