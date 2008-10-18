Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYJRTG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYJRTG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYJRTDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:03:11 -0400
Received: from mx1.suse.de ([195.135.220.2]:38133 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYJRTDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:03:09 -0400
Date: Sat, 18 Oct 2008 11:34:13 -0700
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
       alan@lxorguk.ukuu.org.uk,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>,
       Sujith <Sujith.Manoharan@atheros.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 08/17] ath9k: fix oops on trying to hold the wrong spinlock
Message-ID: <20081018183413.GI14035@suse.de>
References: <20081018182721.521723254@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ath9k-fix-oops-on-trying-to-hold-the-wrong-spinlock.patch"
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit a477e4e6d48d3ac7c7a75bad40585cb391e5c237 upstream

We were trying to hold the wrong spinlock due to a typo
on IEEE80211_BAR_CTL_TID_S's definition. We use this to
compute the tid number and then hold this this tid number's
spinlock.

Tested-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -316,7 +316,7 @@ void ath_descdma_cleanup(struct ath_soft
 #define ATH_RX_TIMEOUT           40      /* 40 milliseconds */
 #define WME_NUM_TID              16
 #define IEEE80211_BAR_CTL_TID_M  0xF000  /* tid mask */
-#define IEEE80211_BAR_CTL_TID_S  2       /* tid shift */
+#define IEEE80211_BAR_CTL_TID_S  12      /* tid shift */
 
 enum ATH_RX_TYPE {
 	ATH_RX_NON_CONSUMED = 0,

-- 
