Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbYBWAta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbYBWAta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935747AbYBWAgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:36:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:45025 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935651AbYBWAgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:36:07 -0500
Date: Fri, 22 Feb 2008 16:31:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oneukum@suse.de>, Pete Zaitcev <zaitcev@redhat.com>
Subject: [patch 32/38] USB: fix pm counter leak in usblp
Message-ID: <20080223003125.GG7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-pm-counter-leak-in-usblp.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Oliver Neukum <oliver@neukum.org>

commit 1902869019918411c148c18cc3a22aade569ac9a upstream

if you fail in open() you must decrement the pm counter again.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/usblp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -428,6 +428,7 @@ static int usblp_open(struct inode *inod
 	usblp->rcomplete = 0;
 
 	if (handle_bidir(usblp) < 0) {
+		usb_autopm_put_interface(intf);
 		usblp->used = 0;
 		file->private_data = NULL;
 		retval = -EIO;

-- 
