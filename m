Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbZDWHzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbZDWHzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbZDWHeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:34:07 -0400
Received: from sous-sol.org ([216.99.217.87]:51025 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756648AbZDWHeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:34:03 -0400
Message-Id: <20090423072930.408548377@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 080/100] USB: fix oops in cdc-wdm in case of malformed descriptors
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=usb-fix-oops-in-cdc-wdm-in-case-of-malformed-descriptors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Oliver Neukum <oliver@neukum.org>

upstream commit: e13c594f3a1fc2c78e7a20d1a07974f71e4b448f

cdc-wdm needs to ignore extremely malformed descriptors.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -652,7 +652,7 @@ next_desc:
 
 	iface = &intf->altsetting[0];
 	ep = &iface->endpoint[0].desc;
-	if (!usb_endpoint_is_int_in(ep)) {
+	if (!ep || !usb_endpoint_is_int_in(ep)) {
 		rv = -EINVAL;
 		goto err;
 	}

