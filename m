Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbXLMGim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbXLMGim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbXLMGgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:36:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56225 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbXLMGgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:36:52 -0500
Date: Wed, 12 Dec 2007 22:34:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oneukum@suse.de>
Subject: [patch 04/36] USB: make the microtek driver and HAL cooperate
Message-ID: <20071213063406.GE25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-make-the-microtek-driver-and-hal-cooperate.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Oliver Neukum <oliver@neukum.org>

patch 5cf1973a44bd298e3cfce6f6af8faa8c9d0a6d55 in mainline

to make HAL like the microtek driver's devices the parent must be
correctly set.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/image/microtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -823,7 +823,7 @@ static int mts_usb_probe(struct usb_inte
 		goto out_kfree2;
 
 	new_desc->host->hostdata[0] = (unsigned long)new_desc;
-	if (scsi_add_host(new_desc->host, NULL)) {
+	if (scsi_add_host(new_desc->host, &dev->dev)) {
 		err_retval = -EIO;
 		goto out_host_put;
 	}

-- 
