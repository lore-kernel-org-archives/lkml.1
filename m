Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbXCSPKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbXCSPKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbXCSPKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:10:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:39115 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314AbXCSPKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=E2B2curEYYW+Kj58De4+0sVaapelF4xlbvz5+tkmI6okX9QHRa6mZv1VXQJgErNkpfB3C7KQQTGWc12dQtQOwpZquV7Qc8CltjYmjmU7c4vZaxeDt7R35iSJY3NqVx5+DE/X5avhd7EHUz/7RQr0MjQg1QHw1tK9glxi4ujegXQ=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][2/5][resend] floppy.c: Remove pointless register keywords
Date: Mon, 19 Mar 2007 16:10:29 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703191610.30571.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


    This patch removes the use of the 'register' keyword from floppy.c
    
    Marking some variables 'register' may have made sense in the past (though I
    doubt it for these ones), but these days I very much suspect that we would
    rather grant gcc more freedom in how to handle the variables and I doubt
    very much that in this day and age optimizing access to variables via
    'register' makes any sense for a floppy driver.  Let's just get rid of it.
    
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5da54b8..dea7c4f 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -791,7 +791,7 @@ static inline int is_selected(int dor, int unit)
 
 static int set_dor(int fdc, char mask, char data)
 {
-	register unsigned char drive, unit, newdor, olddor;
+	unsigned char drive, unit, newdor, olddor;
 
 	if (FDCS->address == -1)
 		return -1;
@@ -946,7 +946,7 @@ static void motor_off_callback(unsigned long nr)
 static void floppy_off(unsigned int drive)
 {
 	unsigned long volatile delta;
-	register int fdc = FDC(drive);
+	int fdc = FDC(drive);
 
 	if (!(FDCS->dor & (0x10 << UNIT(drive))))
 		return;
