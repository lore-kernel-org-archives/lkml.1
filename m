Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbYJXElz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbYJXElz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYJXEjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:13 -0400
Received: from kroah.org ([198.145.64.141]:51694 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751850AbYJXEjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:09 -0400
Date: Thu, 23 Oct 2008 21:33:54 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>
Subject: [patch 07/27] USB: fix memory leak in cdc-acm
Message-ID: <20081024043354.GH30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename="usb-fix-memory-leak-in-cdc-acm.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Oliver Neukum <oliver@neukum.org>

commit a496c64f1363ec4d67ebdc1e1f619ad6372a574c upstream

This fixes a memory leak on disconnect in cdc-acm

Thanks to 施金前 for finding it.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -849,9 +849,10 @@ static void acm_write_buffers_free(struc
 {
 	int i;
 	struct acm_wb *wb;
+	struct usb_device *usb_dev = interface_to_usbdev(acm->control);
 
 	for (wb = &acm->wb[0], i = 0; i < ACM_NW; i++, wb++) {
-		usb_buffer_free(acm->dev, acm->writesize, wb->buf, wb->dmah);
+		usb_buffer_free(usb_dev, acm->writesize, wb->buf, wb->dmah);
 	}
 }
 

-- 
