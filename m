Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbZCNBsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbZCNBsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZCNBVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:32 -0400
Received: from kroah.org ([198.145.64.141]:35574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754520AbZCNBU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:42 2009
Message-Id: <20090314011042.780575799@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Meelis Roos <mroos@linux.ee>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 077/114] fore200: fix oops on failed firmware load
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=fore200-fix-oops-on-failed-firmware-load.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Meelis Roos <mroos@linux.ee>

commit fcffd0d8bbddac757cd856e635ac75e8eb4518bc upstream.

Fore 200 ATM driver fails to handle request_firmware failures and oopses
when no firmware file was found. Fix it by checking for the right return
values and propaganting the return value up.

Signed-off-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/atm/fore200e.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -2519,8 +2519,8 @@ fore200e_load_and_start_fw(struct fore20
 	return err;
 
     sprintf(buf, "%s%s", fore200e->bus->proc_name, FW_EXT);
-    if (request_firmware(&firmware, buf, device) == 1) {
-	printk(FORE200E "missing %s firmware image\n", fore200e->bus->model_name);
+    if ((err = request_firmware(&firmware, buf, device)) < 0) {
+	printk(FORE200E "problem loading firmware image %s\n", fore200e->bus->model_name);
 	return err;
     }
 


