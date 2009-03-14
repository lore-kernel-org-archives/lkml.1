Return-Path: <linux-kernel-owner+w=401wt.eu-S1751619AbZCNAql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbZCNAql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZCNAT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:56 -0400
Received: from kroah.org ([198.145.64.141]:35002 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751198AbZCNATl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:51 2009
Message-Id: <20090314000751.215689207@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:28 -0700
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
       alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
       Hans de Goede <hdegoede@redhat.com>
Subject: [patch 80/96] hwmon: (f71882fg) Hide misleading error message
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-hide-misleading-error-message.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 603eaa1bdd3e0402085e815cc531bb0a32827a9e upstream

If the F71882FG chip is at address 0x4e, then the probe at 0x2e will
fail with the following message in the logs:
f71882fg: Not a Fintek device

This is misleading because there is a Fintek device, just at a
different address. So I propose to degrade this message to a debug
message.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Hans de Goede <hdegoede@redhat.com>


---
 drivers/hwmon/f71882fg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -837,7 +837,7 @@ static int __init f71882fg_find(int sioa
 
 	devid = superio_inw(sioaddr, SIO_REG_MANID);
 	if (devid != SIO_FINTEK_ID) {
-		printk(KERN_INFO DRVNAME ": Not a Fintek device\n");
+		pr_debug(DRVNAME ": Not a Fintek device\n");
 		goto exit;
 	}
 


