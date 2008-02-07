Return-Path: <linux-kernel-owner+w=401wt.eu-S1763018AbYBGVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763018AbYBGVLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbYBGUyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:54:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933694AbYBGUyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:54:03 -0500
Date: Thu, 7 Feb 2008 12:48:12 -0800
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
       linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
       Michael Buesch <mb@bu3sch.de>
Subject: [patch 39/45] b43: Reject new firmware early
Message-ID: <20080207204812.GN16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-reject-new-firmware-early.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Buesch <mb@bu3sch.de>

(not in mainline, as it is not applicable.)

We must reject new incompatible firmware early to avoid
running into strange transmission failures.

The current development tree supports newer firmware revisions.
These revisions cause strange failures on the stable 2.6.24 kernel.
Add a check to avoid confusing users a lot.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1800,6 +1800,18 @@ static int b43_upload_microcode(struct b
 		err = -EOPNOTSUPP;
 		goto out;
 	}
+	if (fwrev > 351) {
+		b43err(dev->wl, "YOUR FIRMWARE IS TOO NEW. Please downgrade your "
+		       "firmware.\n");
+		b43err(dev->wl, "Use this firmware tarball: "
+		       "http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2\n");
+		b43err(dev->wl, "Use this b43-fwcutter tarball: "
+		       "http://bu3sch.de/b43/fwcutter/b43-fwcutter-009.tar.bz2\n");
+		b43err(dev->wl, "Read, understand and _do_ what this message says, please.\n");
+		b43_write32(dev, B43_MMIO_MACCTL, 0);
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 	b43dbg(dev->wl, "Loading firmware version %u.%u "
 	       "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
 	       fwrev, fwpatch,

-- 
