Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbYHDVpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbYHDVpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765981AbYHDVnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:43:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:55371 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765961AbYHDVnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:43:11 -0400
Date: Mon, 4 Aug 2008 14:30:51 -0700
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
       alan@lxorguk.ukuu.org.uk, greg@kroah.com, chrisw@sous-sol.org,
       Jiri Slaby <jirislaby@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Nick Kossifidis <mickflemm@gmail.com>
Subject: [patch 25/25] Ath5k: kill tasklets on shutdown
Message-ID: <20080804213051.GY8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ath5k-kill-tasklets-on-shutdown.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 10488f8ad62be3b860bad74e60b4fe6ab87aece3 upstream

Don't forget to kill tasklets on stop to not panic if they
fire after freeing some structures.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath5k/base.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2453,6 +2453,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	mutex_unlock(&sc->lock);
 
 	del_timer_sync(&sc->calib_tim);
+	tasklet_kill(&sc->rxtq);
+	tasklet_kill(&sc->txtq);
+	tasklet_kill(&sc->restq);
 
 	return ret;
 }

-- 
