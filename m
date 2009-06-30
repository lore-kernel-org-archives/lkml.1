Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbZGAAbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbZGAAbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbZGAA37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:29:59 -0400
Received: from kroah.org ([198.145.64.141]:34309 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759560AbZGAA36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:29:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:03:57 2009
Message-Id: <20090701000356.957554861@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 16:59:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Peter Botha" <peterb@goldcircle.co.za>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [patch 05/30] char: mxser, fix ISA board lookup
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=char-mxser-fix-isa-board-lookup.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Botha <peterb@goldcircle.co.za>

commit 96050dfb25966612008dcea7d342e91fa01e993c upstream.

There's a bug in the mxser kernel module that still appears in the
2.6.29.4 kernel.

mxser_get_ISA_conf takes a ioaddress as its first argument, by passing the
not of the ioaddr, you're effectively passing 0 which means it won't be
able to talk to an ISA card.  I have tested this, and removing the !
fixes the problem.

Cc: "Peter Botha" <peterb@goldcircle.co.za>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/mxser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -2790,7 +2790,7 @@ static int __init mxser_module_init(void
 			continue;
 
 		brd = &mxser_boards[m];
-		retval = mxser_get_ISA_conf(!ioaddr[b], brd);
+		retval = mxser_get_ISA_conf(ioaddr[b], brd);
 		if (retval <= 0) {
 			brd->info = NULL;
 			continue;


