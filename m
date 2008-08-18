Return-Path: <linux-kernel-owner+w=401wt.eu-S933194AbYHRTbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbYHRTbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761879AbYHRTaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:30:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757649AbYHRTaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:30:22 -0400
Date: Mon, 18 Aug 2008 12:19:46 -0700
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
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@tv-sign.ru>,
       Mark McLoughlin <markmc@redhat.com>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 14/49] posix-timers: do_schedule_next_timer: fix the
	setting of ->si_overrun
Message-ID: <20080818191946.GO10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@tv-sign.ru>

commit 54da1174922cddd4be83d5a364b2e0fdd693f513 upstream

do_schedule_next_timer() sets info->si_overrun = timr->it_overrun_last,
this discards the already accumulated overruns.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Mark McLoughlin <markmc@redhat.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/posix-timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -290,7 +290,7 @@ void do_schedule_next_timer(struct sigin
 		else
 			schedule_next_timer(timr);
 
-		info->si_overrun = timr->it_overrun_last;
+		info->si_overrun += timr->it_overrun_last;
 	}
 
 	if (timr)

-- 
