Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZGAA5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZGAA5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761426AbZGAAeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:44 -0400
Received: from kroah.org ([198.145.64.141]:60315 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761423AbZGAAen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:25 2009
Message-Id: <20090701002425.484463869@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Brownell <david-b@pacbell.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@gate.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [patch 040/108] spi: takes size of a pointer to determine the size of the pointed-to type
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=spi-takes-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit 021415468c889979117b1a07b96f7e36de33e995 upstream.

Do not take the size of a pointer to determine the size of the pointed-to
type.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/spi/spi_mpc83xx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi_mpc83xx.c
+++ b/drivers/spi/spi_mpc83xx.c
@@ -711,12 +711,12 @@ static int of_mpc83xx_spi_get_chipselect
 		return 0;
 	}
 
-	pinfo->gpios = kmalloc(ngpios * sizeof(pinfo->gpios), GFP_KERNEL);
+	pinfo->gpios = kmalloc(ngpios * sizeof(*pinfo->gpios), GFP_KERNEL);
 	if (!pinfo->gpios)
 		return -ENOMEM;
-	memset(pinfo->gpios, -1, ngpios * sizeof(pinfo->gpios));
+	memset(pinfo->gpios, -1, ngpios * sizeof(*pinfo->gpios));
 
-	pinfo->alow_flags = kzalloc(ngpios * sizeof(pinfo->alow_flags),
+	pinfo->alow_flags = kzalloc(ngpios * sizeof(*pinfo->alow_flags),
 				    GFP_KERNEL);
 	if (!pinfo->alow_flags) {
 		ret = -ENOMEM;


