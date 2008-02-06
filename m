Return-Path: <linux-kernel-owner+w=401wt.eu-S1764522AbYBGAC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764522AbYBGAC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764329AbYBFXy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:45318 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764324AbYBFXyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:55 -0500
Date: Wed, 6 Feb 2008 15:51:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Russ Dill <Russ.Dill@asu.edu>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/73] NET: mcs7830 passes msecs instead of jiffies to
	usb_control_msg
Message-ID: <20080206235148.GR13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-mcs7830-passes-msecs-instead-of-jiffies-to-usb_control_msg.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Russ Dill <Russ.Dill@asu.edu>

[NET]: mcs7830 passes msecs instead of jiffies to usb_control_msg

[ Upstream commit 1d39da3dcaad4231f0fa75024b1d6d710a2ced74 ]

usb_control_msg was changed long ago (2.6.12-pre) to take milliseconds
instead of jiffies. Oddly, mcs7830 wasn't added until 2.6.19-rc3.

Signed-off-by: Russ Dill <Russ.Dill@asu.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/mcs7830.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -94,7 +94,7 @@ static int mcs7830_get_reg(struct usbnet
 
 	ret = usb_control_msg(xdev, usb_rcvctrlpipe(xdev, 0), MCS7830_RD_BREQ,
 			      MCS7830_RD_BMREQ, 0x0000, index, data,
-			      size, msecs_to_jiffies(MCS7830_CTRL_TIMEOUT));
+			      size, MCS7830_CTRL_TIMEOUT);
 	return ret;
 }
 
@@ -105,7 +105,7 @@ static int mcs7830_set_reg(struct usbnet
 
 	ret = usb_control_msg(xdev, usb_sndctrlpipe(xdev, 0), MCS7830_WR_BREQ,
 			      MCS7830_WR_BMREQ, 0x0000, index, data,
-			      size, msecs_to_jiffies(MCS7830_CTRL_TIMEOUT));
+			      size, MCS7830_CTRL_TIMEOUT);
 	return ret;
 }
 

-- 
