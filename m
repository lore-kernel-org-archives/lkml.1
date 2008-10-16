Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbYJPSCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbYJPSCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbYJPSAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:00:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:46721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbYJPSAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:00:35 -0400
Date: Thu, 16 Oct 2008 10:56:30 -0700
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
Subject: [patch 05/14] tty: Termios locking - sort out real_tty confusions
	and lock reads
Message-ID: <20081016175630.GF12850@suse.de>
References: <20081016174814.734527827@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tty-termios-locking-sort-out-real_tty-confusions-and-lock-reads.patch"
In-Reply-To: <20081016175525.GA12850@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
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
@@ -2996,7 +2996,7 @@ long tty_ioctl(struct file *file, unsign
 	case TIOCSTI:
 		return tiocsti(tty, p);
 	case TIOCGWINSZ:
-		return tiocgwinsz(tty, p);
+		return tiocgwinsz(real_tty, p);
 	case TIOCSWINSZ:
 		return tiocswinsz(tty, real_tty, p);
 	case TIOCCONS:

-- 
