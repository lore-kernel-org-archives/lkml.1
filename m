Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYJRTVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYJRTVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYJRTGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:06:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:47868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYJRTGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:06:06 -0400
Date: Sat, 18 Oct 2008 11:57:21 -0700
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
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@redhat.com>
Subject: [patch 04/14] tty: Termios locking - sort out real_tty confusions
	and lock reads
Message-ID: <20081018185721.GE17196@suse.de>
References: <20081018185031.236868964@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tty-termios-locking-sort-out-real_tty-confusions-and-lock-reads.patch"
In-Reply-To: <20081018185658.GA17196@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Alan Cox <alan@redhat.com>

commit 8f520021837d45c47d0ab57e7271f8d88bf7f3a4 upstream

(only the tty_io.c portion of this commit)

This moves us towards sanity and should mean our termios locking is now
complete and comprehensive.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3373,7 +3373,7 @@ int tty_ioctl(struct inode *inode, struc
 	case TIOCSTI:
 		return tiocsti(tty, p);
 	case TIOCGWINSZ:
-		return tiocgwinsz(tty, p);
+		return tiocgwinsz(real_tty, p);
 	case TIOCSWINSZ:
 		return tiocswinsz(tty, real_tty, p);
 	case TIOCCONS:

-- 
