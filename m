Return-Path: <linux-kernel-owner+w=401wt.eu-S1761954AbZFIKaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954AbZFIKaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760794AbZFIKUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:32 -0400
Received: from kroah.org ([198.145.64.141]:55148 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760785AbZFIKUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:31 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:04 2009
Message-Id: <20090609094104.729987455@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:42 -0700
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
       alan@lxorguk.ukuu.org.uk, Zoltan Karcagi <zkr@freemail.hu>,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 54/87] HID: fix dropped device-specific quirks
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=hid-fix-dropped-device-specific-quirks.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zoltan Karcagi <zkr@freemail.hu>

commit f5208997087e6eb2096532b5a313eeb236535bdc upstream.

Device-specific quirks are set up correctly in their respective vendor-specific
driver, then get overwritten in usbhid_parse().

This is only issue for device-specific NOGET quirks being set by driver for a
few devices out there.

Signed-off-by: Zoltan Karcagi <zkr@freemail.hu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/usbhid/hid-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -765,7 +765,7 @@ static int usbhid_parse(struct hid_devic
 		goto err;
 	}
 
-	hid->quirks = quirks;
+	hid->quirks |= quirks;
 
 	return 0;
 err:


