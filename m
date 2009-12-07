Return-Path: <linux-kernel-owner+w=401wt.eu-S934580AbZLGAcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934580AbZLGAcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934504AbZLGAcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:32:42 -0500
Received: from kroah.org ([198.145.64.141]:34306 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758334AbZLGAMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:52 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:45 2009
Message-Id: <20091207000645.634727566@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, Raphael Assenat <raph@8d.com>
Subject: [033/119] rtc: v3020: fix v3020_mmio_read_bit()
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=rtc-v3020-fix-v3020_mmio_read_bit.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Scott Valentine <svalentine@concentris-systems.com>

commit bcb3a1676b87effbdeffe8da5c44f63433d158d9 upstream.

v3020_mmio_read_bit() always returns 0 when left_shift > 7.

v3020_mmio_read_bit()'s return type is (unsigned char).  The code returns
a value masked by (1 << left_shift) that is casted to the return type.  If
left_shift is larger than 7, the cast will always result in a 0 return
value.  The problem was discovered with left_shift = 16, and the included
patch corrects the problem.

The bug was introduced in the last (Apr 3 2009) commit of the file, kernel
versions 2.6.30 and later.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Raphael Assenat <raph@8d.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-v3020.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -96,7 +96,7 @@ static void v3020_mmio_write_bit(struct 
 
 static unsigned char v3020_mmio_read_bit(struct v3020 *chip)
 {
-	return readl(chip->ioaddress) & (1 << chip->leftshift);
+	return !!(readl(chip->ioaddress) & (1 << chip->leftshift));
 }
 
 static struct v3020_chip_ops v3020_mmio_ops = {


