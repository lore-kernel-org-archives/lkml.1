Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbZD3R2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbZD3R2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764641AbZD3RIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:05 -0400
Received: from kroah.org ([198.145.64.141]:56598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764624AbZD3RHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:45 2009
Message-Id: <20090430165745.330358107@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:36 -0700
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
Subject: [patch 47/88] USB: fix oops in cdc-wdm in case of malformed descriptors
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0079-USB-fix-oops-in-cdc-wdm-in-case-of-malformed-descri.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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
@@ -652,7 +652,7 @@ next_desc:
 
 	iface = &intf->altsetting[0];
 	ep = &iface->endpoint[0].desc;
-	if (!usb_endpoint_is_int_in(ep)) {
+	if (!ep || !usb_endpoint_is_int_in(ep)) {
 		rv = -EINVAL;
 		goto err;
 	}


