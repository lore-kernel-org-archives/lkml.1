Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbZD2We7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbZD2We7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbZD2WVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:41 -0400
Received: from kroah.org ([198.145.64.141]:40532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759743AbZD2WVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:28 2009
Message-Id: <20090429220928.432626483@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:35 -0700
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
       alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 36/58] USB: fix oops in cdc-wdm in case of malformed descriptors
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0079-USB-fix-oops-in-cdc-wdm-in-case-of-malformed-descri.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oliver@neukum.org>

upstream commit: e13c594f3a1fc2c78e7a20d1a07974f71e4b448f

cdc-wdm needs to ignore extremely malformed descriptors.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -641,7 +641,7 @@ next_desc:
 
 	iface = &intf->altsetting[0];
 	ep = &iface->endpoint[0].desc;
-	if (!usb_endpoint_is_int_in(ep)) {
+	if (!ep || !usb_endpoint_is_int_in(ep)) {
 		rv = -EINVAL;
 		goto err;
 	}


