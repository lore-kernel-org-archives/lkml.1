Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbZFIK3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbZFIK3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760789AbZFIKUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:21 -0400
Received: from kroah.org ([198.145.64.141]:55099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760787AbZFIKUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:20 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:04 2009
Message-Id: <20090609094104.039304013@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:39 -0700
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
       alan@lxorguk.ukuu.org.uk, "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 51/87] mac80211: avoid NULL ptr deref when finding max_rates in PID and minstrel
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=mac80211-avoid-null-ptr-deref-when-finding-max_rates-in-pid-and-minstrel.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit 621ad7c96aa138cfeab53cd4debc5a4e08b2189b upstream.

"There is another problem with this piece of code. The sband will be NULL
after second iteration on single band device and cause null pointer
dereference. Everything is working with dual band card. Sorry, but i
don't know how to explain this clearly in English. I have looked on the
second patch for pid algorithm and found similar bug."

Reported-by: Karol Szuster <qflon@o2.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rc80211_minstrel.c |    2 +-
 net/mac80211/rc80211_pid_algo.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -477,7 +477,7 @@ minstrel_alloc_sta(void *priv, struct ie
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		sband = hw->wiphy->bands[i];
-		if (sband->n_bitrates > max_rates)
+		if (sband && sband->n_bitrates > max_rates)
 			max_rates = sband->n_bitrates;
 	}
 
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -378,7 +378,7 @@ static void *rate_control_pid_alloc(stru
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		sband = hw->wiphy->bands[i];
-		if (sband->n_bitrates > max_rates)
+		if (sband && sband->n_bitrates > max_rates)
 			max_rates = sband->n_bitrates;
 	}
 


