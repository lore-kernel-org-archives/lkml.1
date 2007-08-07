Return-Path: <linux-kernel-owner+w=401wt.eu-S936888AbXHGVNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936888AbXHGVNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965064AbXHGUy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:54:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59586 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965051AbXHGUyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:54:25 -0400
Date: Tue, 7 Aug 2007 13:47:22 -0700
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
       linux-wireless@vger.kernel.org, Jean Tourrilhes <jt@hpl.hp.com>,
       Michael Buesch <mb@bu3sch.df>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [2.6.22.2 review 49/84] softmac: Fix ESSID problem
Message-ID: <20070807204722.GY23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="softmac-fix-essid-problem.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jean Tourrilhes <jt@hpl.hp.com>

Victor Porton reported that the SoftMAC layer had random problem when setting the ESSID :
http://bugzilla.kernel.org/show_bug.cgi?id=8686 After investigation, it turned out to be
worse, the SoftMAC layer is left in an inconsistent state. The fix is pretty trivial.

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
Acked-by: Michael Buesch <mb@bu3sch.df>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ieee80211/softmac/ieee80211softmac_assoc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ieee80211/softmac/ieee80211softmac_assoc.c
+++ b/net/ieee80211/softmac/ieee80211softmac_assoc.c
@@ -271,8 +271,11 @@ ieee80211softmac_assoc_work(struct work_
 			 */
 			dprintk(KERN_INFO PFX "Associate: Scanning for networks first.\n");
 			ieee80211softmac_notify(mac->dev, IEEE80211SOFTMAC_EVENT_SCAN_FINISHED, ieee80211softmac_assoc_notify_scan, NULL);
-			if (ieee80211softmac_start_scan(mac))
+			if (ieee80211softmac_start_scan(mac)) {
 				dprintk(KERN_INFO PFX "Associate: failed to initiate scan. Is device up?\n");
+				mac->associnfo.associating = 0;
+				mac->associnfo.associated = 0;
+			}
 			goto out;
 		} else {
 			mac->associnfo.associating = 0;

-- 
