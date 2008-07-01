Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYGAPXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYGAPXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbYGAPWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:22:16 -0400
Received: from ns.suse.de ([195.135.220.2]:43267 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759169AbYGAPWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:22:13 -0400
Date: Tue, 1 Jul 2008 08:19:08 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jie Luo <clotho67@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 4/9] DRM: enable bus mastering on i915 at resume time
Message-ID: <20080701151908.GE3536@suse.de>
References: <20080701151057.930340322@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drm-enable-bus-mastering-on-i915-at-resume-time.patch"
In-Reply-To: <20080701151835.GA3536@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Jie Luo <clotho67@gmail.com>

commit ea7b44c8e6baa1a4507f05ba2c0009ac21c3fe0b upstream

On 9xx chips, bus mastering needs to be enabled at resume time for much of the
chip to function.  With this patch, vblank interrupts will work as expected
on resume, along with other chip functions.   Fixes kernel bugzilla #10844.

Signed-off-by: Jie Luo <clotho67@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/drm/i915_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/drm/i915_drv.c
+++ b/drivers/char/drm/i915_drv.c
@@ -385,6 +385,7 @@ static int i915_resume(struct drm_device
 	pci_restore_state(dev->pdev);
 	if (pci_enable_device(dev->pdev))
 		return -1;
+	pci_set_master(dev->pdev);
 
 	pci_write_config_byte(dev->pdev, LBB, dev_priv->saveLBB);
 

-- 
