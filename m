Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbXIXQcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbXIXQcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760384AbXIXQ0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:07 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47397 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760391AbXIXQ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:04 -0400
Date: Mon, 24 Sep 2007 09:21:04 -0700
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
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: [20/50] disable sys_timerfd()
Message-ID: <20070924162104.GU13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="disable-sys_timerfd.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

commit e42601973b1bce1d2987f82159c1ebeaccc6b310 in mainline.

There is still some confusion and disagreement over what this interface should
actually do.  So it is best that we disable it in 2.6.23 until we get that
fully sorted out.

(sys_timerfd() was present in 2.6.22 but it was apparently broken, so here we
assume that nobody is using it yet).

Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -505,6 +505,7 @@ config SIGNALFD
 config TIMERFD
 	bool "Enable timerfd() system call" if EMBEDDED
 	depends on ANON_INODES
+	depends on BROKEN
 	default y
 	help
 	  Enable the timerfd() system call that allows to receive timer

-- 
