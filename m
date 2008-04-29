Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbYD2R3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbYD2R3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbYD2RV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:29 -0400
Received: from mx1.suse.de ([195.135.220.2]:52194 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905AbYD2RV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:27 -0400
Date: Tue, 29 Apr 2008 10:18:48 -0700
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
       linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Gabor Stefanik <netrolller.3d@gmail.com>, Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [22/37] ssb: Fix all-ones boardflags
Message-ID: <20080429171848.GW14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ssb-fix-all-ones-boardflags.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Larry Finger <Larry.Finger@lwfinger.net>

commit 4503183aa32e6886400d82282292934fa64a81b0 upstream

In the SSB SPROM a field set to all ones means the value
is not defined in the SPROM.
In case of the boardflags, we need to set them to zero
to avoid confusing drivers. Drivers will only check the
flags by ANDing.


Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Gabor Stefanik <netrolller.3d@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ssb/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -482,6 +482,11 @@ static int sprom_extract(struct ssb_bus 
 			goto unsupported;
 	}
 
+	if (out->boardflags_lo == 0xFFFF)
+		out->boardflags_lo = 0;  /* per specs */
+	if (out->boardflags_hi == 0xFFFF)
+		out->boardflags_hi = 0;  /* per specs */
+
 	return 0;
 unsupported:
 	ssb_printk(KERN_WARNING PFX "Unsupported SPROM revision %d "

-- 
