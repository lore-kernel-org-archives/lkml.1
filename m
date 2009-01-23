Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbZAWBSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbZAWBSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760144AbZAWBOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:14:53 -0500
Received: from kroah.org ([198.145.64.141]:50488 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760126AbZAWBOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:52 -0500
Date: Thu, 22 Jan 2009 17:11:58 -0800
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/46] drivers/net/irda/irda-usb.c: fix buffer overflow
Message-ID: <20090123011158.GP19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drivers-net-irda-irda-usb.c-fix-buffer-overflow.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jos-Vicente Gilabert <josevteg@gmail.com>

commit 2950e952920811be465ec95c6b56f03dc66a05c0 upstream.

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=12397

We're doing an sprintf of an 11-char string into an 11-char buffer.
Whoops.  It breaks firmware uploading.

Reported-by: Jos-Vicente Gilabert <josevteg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/irda/irda-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/irda/irda-usb.c
+++ b/drivers/net/irda/irda-usb.c
@@ -1075,7 +1075,7 @@ static int stir421x_patch_device(struct 
 {
 	unsigned int i;
 	int ret;
-	char stir421x_fw_name[11];
+	char stir421x_fw_name[12];
 	const struct firmware *fw;
 	const unsigned char *fw_version_ptr; /* pointer to version string */
 	unsigned long fw_version = 0;

