Return-Path: <linux-kernel-owner+w=401wt.eu-S935556AbYBGVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935556AbYBGVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933774AbYBGUyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:54:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:38947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933767AbYBGUys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:54:48 -0500
Date: Thu, 7 Feb 2008 12:48:26 -0800
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
       Dave Airlie <airlied@linux.ie>
Subject: [patch 45/45] drm: the drm really should call pci_set_master..
Message-ID: <20080207204826.GT16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drm-the-drm-really-should-call-pci_set_master.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Airlie <airlied@linux.ie>


(submitted upstream as 19a8f59ab8ceee751ea720085098355d53f727d6)

perhaps bonghits could turn on my bus-mastering because the drm
certainly never bothered doing it before.

Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/drm/drm_stub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/drm/drm_stub.c
+++ b/drivers/char/drm/drm_stub.c
@@ -218,6 +218,7 @@ int drm_get_dev(struct pci_dev *pdev, co
 	if (ret)
 		goto err_g1;
 
+	pci_set_master(pdev);
 	if ((ret = drm_fill_in_dev(dev, pdev, ent, driver))) {
 		printk(KERN_ERR "DRM: Fill_in_dev failed.\n");
 		goto err_g2;

-- 
