Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZA3JGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZA3JGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZA3JFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:05:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52264 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbZA3JFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:05:30 -0500
Date: Fri, 30 Jan 2009 10:05:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] w35und: fix registration with wlan stack
Message-ID: <20090130090525.GA1997@elf.ucw.cz>
References: <497E1F3A.1060604@cs.helsinki.fi> <497E2EC4.5030302@gmail.com> <497E35A1.8080301@cs.helsinki.fi> <497F5FEA.7020203@gmail.com> <20090127200602.GA16444@elf.ucw.cz> <4980B2DD.307@gmail.com> <4980BB9A.2020309@cs.helsinki.fi> <4980C028.2030709@gmail.com> <4980C035.4070105@cs.helsinki.fi> <4980DB5D.6010906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4980DB5D.6010906@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize few more fields in wireless device structure so that
wireless core actually accepts our registration.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 87290671d60a4f0e734f389a266b13d71c275ce4
tree c8e312a3ef0b0d250c1e605ce86bff94c0254847
parent e6de9be58f118cba6ccfef28830db701b8cc9f46
author Pavel <pavel@suse.cz> Fri, 30 Jan 2009 09:08:36 +0100
committer Pavel <pavel@suse.cz> Fri, 30 Jan 2009 09:08:36 +0100

 drivers/staging/winbond/wbusb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index b003f9a..49f1bf0 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -369,9 +369,11 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	}
 
 	dev->extra_tx_headroom = 12;	/* FIXME */
-	dev->flags = 0;
+	dev->flags = IEEE80211_HW_SIGNAL_UNSPEC;
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	dev->channel_change_time = 1000;
+	dev->max_signal = 100;
 	dev->queues = 1;
 
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &wbsoft_band_2GHz;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
