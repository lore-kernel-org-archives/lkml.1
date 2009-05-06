Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbZEFWTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbZEFWTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761563AbZEFVzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:25 -0400
Received: from kroah.org ([198.145.64.141]:57492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761416AbZEFVzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:55:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:03 2009
Message-Id: <20090506214803.386675010@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:26 -0700
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
       alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
       Alina Friedrichsen <x-alina@gmx.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jouni Malinen <Jouni.Malinen@atheros.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [patch 58/58] ath9k: Fix FIF_BCN_PRBRESP_PROMISC handling
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=ath9k-fix-fif_bcn_prbresp_promisc-handling.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@Atheros.com>

This is a port of commit
91ed19f5f66a7fe544f0ec385e981f43491d1d5a
for 2.6.29.

Without this after scanning your device will set
the association ID to something bogus and what is
being reported is multicast/broadcast frame are not
being received. For details see this bug report:

https://bugzilla.redhat.com/show_bug.cgi?id=498502

>From the original commit:

So that a new created IBSS network
doesn't break on the first scan.

It seems to Sujith and me that this
stupid code unnecessary, too.

So remove it...

Reported-by: David Woodhouse <dwmw2@infradead.org>
Tested-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jouni Malinen <Jouni.Malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/main.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2300,11 +2300,6 @@ static void ath9k_configure_filter(struc
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
 
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			ath9k_hw_write_associd(sc->sc_ah, ath_bcast_mac, 0);
-	}
-
 	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", sc->rx.rxfilter);
 }
 


