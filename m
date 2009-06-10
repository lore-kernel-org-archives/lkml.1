Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbZFJDj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbZFJDj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZFJDem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:34:42 -0400
Received: from kroah.org ([198.145.64.141]:56917 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679AbZFJDel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:34:41 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:45 2009
Message-Id: <20090610002345.261504798@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:52 -0700
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
       alan@lxorguk.ukuu.org.uk, Mike Frysinger <vapier@gentoo.org>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 24/60] hwmon: (lm78) Add missing __devexit_p()
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=hwmon-add-missing-__devexit_p.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mike Frysinger <vapier@gentoo.org>

commit 39d8bbedb9571a89d638f5b05358f26ab503d7a6 upstream.

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/lm78.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -178,7 +178,7 @@ static struct platform_driver lm78_isa_d
 		.name	= "lm78",
 	},
 	.probe		= lm78_isa_probe,
-	.remove		= lm78_isa_remove,
+	.remove		= __devexit_p(lm78_isa_remove),
 };
 
 


