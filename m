Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYJRTMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYJRTMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYJRTE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:04:28 -0400
Received: from ns1.suse.de ([195.135.220.2]:38402 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbYJRTE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:04:27 -0400
Date: Sat, 18 Oct 2008 11:47:39 -0700
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
       alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 07/26] b43legacy: Fix failure in rate-adjustment mechanism
Message-ID: <20081018184739.GH301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43legacy-fix-failure-in-rate-adjustment-mechanism.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Larry Finger <Larry.Finger@lwfinger.net>

commit c6a2afdacccd56cc0be8e9a7977f0ed1509069f6 upstream
Date: Sat, 6 Sep 2008 16:51:22 -0500
Subject: [patch 07/26] b43legacy: Fix failure in rate-adjustment mechanism

A coding error present since b43legacy was incorporated into the
kernel has prevented the driver from using the rate-setting mechanism
of mac80211. The driver has been forced to remain at a 1 Mb/s rate.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43legacy/xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -626,7 +626,7 @@ void b43legacy_handle_hwtxstatus(struct 
 	tmp = hw->count;
 	status.frame_count = (tmp >> 4);
 	status.rts_count = (tmp & 0x0F);
-	tmp = hw->flags;
+	tmp = hw->flags << 1;
 	status.supp_reason = ((tmp & 0x1C) >> 2);
 	status.pm_indicated = !!(tmp & 0x80);
 	status.intermediate = !!(tmp & 0x40);

-- 
