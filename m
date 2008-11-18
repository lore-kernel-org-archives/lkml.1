Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbYKRLjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbYKRLjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYKRLix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:38:53 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:34480 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYKRLiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:38:52 -0500
Message-Id: <20081118113848.945650506@linux.vnet.ibm.com>
References: <20081118112827.927627788@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Nov 2008 12:28:28 +0100
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: [patch 1/1] hvc_console: fix: hp->ws winsize check runs out-of-sync
Content-Disposition: inline; filename=hvc/common/06_hvc_winsize_check_removal.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

The test to check for a new winsize runs out-of-sync with the underlying
tty. After a tty has been released and initialized again, the winsize might
differ between the tty and the hp struct. 
The solution is to simply remove the check and always schedule the resize work.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 drivers/char/hvc_console.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -689,10 +689,8 @@ EXPORT_SYMBOL_GPL(hvc_poll);
  */
 void hvc_resize(struct hvc_struct *hp, struct winsize ws)
 {
-	if ((hp->ws.ws_row != ws.ws_row) || (hp->ws.ws_col != ws.ws_col)) {
-		hp->ws = ws;
-		schedule_work(&hp->tty_resize);
-	}
+	hp->ws = ws;
+	schedule_work(&hp->tty_resize);
 }
 
 /*

-- 
Hendrik Brueckner
D/3303 Linux on System z Development
Tel: +49 7031 16-1073
Fax: +49 7031 16-3456
eMail: brueckner@linux.vnet.ibm.com
IBM Deutschland Research & Development GmbH, Schoenaicher Str. 220, 71032 Boeblingen

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Erich Baier
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

