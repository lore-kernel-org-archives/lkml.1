Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbZJBBdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbZJBBdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZJBBdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:09 -0400
Received: from kroah.org ([198.145.64.141]:33097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbZJBBdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:12 2009
Message-Id: <20091002012412.879266609@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [045/136] cdc_acm: Fix to use modern speed interfaces
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=cdc_acm-fix-to-use-modern-speed-interfaces.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit 9b80fee149a875a6292b2556ab2c64dc7ab7d6f5 upstream.

This changed in 2006 so its about time the ACM driver caught up

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -860,10 +860,7 @@ static void acm_tty_set_termios(struct t
 	if (!ACM_READY(acm))
 		return;
 
-	/* FIXME: Needs to support the tty_baud interface */
-	/* FIXME: Broken on sparc */
-	newline.dwDTERate = cpu_to_le32p(acm_tty_speed +
-		(termios->c_cflag & CBAUD & ~CBAUDEX) + (termios->c_cflag & CBAUDEX ? 15 : 0));
+	newline.dwDTERate = cpu_to_le32(tty_get_baud_rate(tty));
 	newline.bCharFormat = termios->c_cflag & CSTOPB ? 2 : 0;
 	newline.bParityType = termios->c_cflag & PARENB ?
 				(termios->c_cflag & PARODD ? 1 : 2) +


