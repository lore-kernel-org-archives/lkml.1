Return-Path: <linux-kernel-owner+w=401wt.eu-S965081AbXBEX0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081AbXBEX0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965092AbXBEX0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:26:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:43004 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965100AbXBEX0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:26:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=hli2tMahEeyFS8u2EXD4wfBcIPA7wR8lGc2wz+SDScLMVS50kevg3FW4NUyhR490FYii4OXsggLLUL0QGDLkGa0SIXHOboiSPallIJaaODoltnkw3Qn1eHKgMC1yBIwstB76JlRdRE1Ap3pHSXAwmXVP+07YJ7DK+gEphtbdBXA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][2/5] floppy.c: Remove pointless register keywords
Date: Tue, 6 Feb 2007 00:29:18 +0100
User-Agent: KMail/1.9.4
Cc: Andi Kleen <ak@suse.de>, Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702060029.18796.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch removes the use of the 'register' keyword from floppy.c

Marking some variables 'register' may have made sense in the past (though I 
doubt it for these ones), but these days I very much suspect that we would 
rather grant gcc more freedom in how to handle the variables and I doubt 
very much that in this day and age optimizing access to variables via 
'register' makes any sense for a floppy driver.  Let's just get rid of it.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 floppy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20/drivers/block/floppy.c.patch1	2007-02-05 23:11:03.000000000 +0100
+++ linux-2.6.20/drivers/block/floppy.c	2007-02-05 23:11:31.000000000 +0100
@@ -791,7 +791,7 @@
 
 static int set_dor(int fdc, char mask, char data)
 {
-	register unsigned char drive, unit, newdor, olddor;
+	unsigned char drive, unit, newdor, olddor;
 
 	if (FDCS->address == -1)
 		return -1;
@@ -946,7 +946,7 @@
 static void floppy_off(unsigned int drive)
 {
 	unsigned long volatile delta;
-	register int fdc = FDC(drive);
+	int fdc = FDC(drive);
 
 	if (!(FDCS->dor & (0x10 << UNIT(drive))))
 		return;



