Return-Path: <linux-kernel-owner+w=401wt.eu-S937918AbYBWA4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937918AbYBWA4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937805AbYBWAzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:55:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:58245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937802AbYBWAzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:55:39 -0500
Date: Fri, 22 Feb 2008 16:29:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, rlove@google.com, clem.taylor@gmail.com,
       amy.griffis@hp.com, ulissesf@gmail.com
Subject: [patch 04/38] inotify: fix check for one-shot watches before
	destroying them
Message-ID: <20080223002943.GE7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="inotify-fix-check-for-one-shot-watches-before-destroying-them.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
 
 From: Ulisses Furquim <ulissesf@gmail.com>

patch ac74c00e499ed276a965e5b5600667d5dc04a84a in mainline.

As the IN_ONESHOT bit is never set when an event is sent we must check it
in the watch's mask and not in the event's mask.

Signed-off-by: Ulisses Furquim <ulissesf@gmail.com>
Reported-by: "Clem Taylor" <clem.taylor@gmail.com>
Tested-by: "Clem Taylor" <clem.taylor@gmail.com>
Cc: Amy Griffis <amy.griffis@hp.com>
Cc: Robert Love <rlove@google.com>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/inotify_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -269,7 +269,7 @@ static void inotify_dev_queue_event(stru
 	/* we can safely put the watch as we don't reference it while
 	 * generating the event
 	 */
-	if (mask & IN_IGNORED || mask & IN_ONESHOT)
+	if (mask & IN_IGNORED || w->mask & IN_ONESHOT)
 		put_inotify_watch(w); /* final put */
 
 	/* coalescing: drop this event if it is a dupe of the previous */

-- 
