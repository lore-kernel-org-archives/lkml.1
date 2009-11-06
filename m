Return-Path: <linux-kernel-owner+w=401wt.eu-S1760415AbZKFWaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbZKFWaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932620AbZKFWX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:29 -0500
Received: from kroah.org ([198.145.64.141]:57061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605AbZKFWXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:24 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:48 2009
Message-Id: <20091106221548.863722805@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [73/99] b43: Fix Bugzilla #14181 and the bug from the previous fix
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=b43-fix-bugzilla-14181-and-the-bug-from-the-previous-fix.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Larry Finger <Larry.Finger@lwfinger.net>

commit d50bae33d1358b909ade05ae121d83d3a60ab63f upstream.

"b43: Fix PPC crash in rfkill polling on unload" fixed the bug reported
in Bugzilla No. 14181; however, it introduced a new bug. Whenever the
radio switch was turned off, it was necessary to unload and reload
the driver for it to recognize the switch again.

This patch fixes both the original bug in #14181 and the bug introduced by
the previous patch. It must be stated, however, that if there is a BCM4306/3
with an rfkill switch (not yet proven), then the driver will need an
unload/reload cycle to turn the device back on.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/rfkill.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -33,7 +33,8 @@ bool b43_is_hw_radio_enabled(struct b43_
 		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
 			return 1;
 	} else {
-		if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
+		if (b43_status(dev) >= B43_STAT_STARTED &&
+		    b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
 		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
 			return 1;
 	}


