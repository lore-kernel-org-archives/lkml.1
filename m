Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbYD2Rc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbYD2Rc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759361AbYD2RWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:22:01 -0400
Received: from mail.suse.de ([195.135.220.2]:52555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759395AbYD2RV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:59 -0400
Date: Tue, 29 Apr 2008 10:19:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <12o3l@tiscali.nl>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Johannes Weiner <hannes@saeurebad.de>
Subject: [30/37] dz: test after postfix decrement fails in
	dz_console_putchar()
Message-ID: <20080429171908.GE14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Roel Kluin <12o3l@tiscali.nl>

commit 1ecf0d0cd28a4bfed3009f752061998e52d14db2 upstream

When loops reaches 0 the postfix decrement still subtracts, so the subsequent
test fails.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/dz.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/serial/dz.c
+++ b/drivers/serial/dz.c
@@ -819,7 +819,7 @@ static void dz_console_putchar(struct ua
 		dz_out(dport, DZ_TCR, mask);
 		iob();
 		udelay(2);
-	} while (loops--);
+	} while (--loops);
 
 	if (loops)				/* Cannot send otherwise. */
 		dz_out(dport, DZ_TDR, ch);

-- 
