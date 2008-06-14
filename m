Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbYFNAQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbYFNAQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbYFNANG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:13:06 -0400
Received: from mx1.suse.de ([195.135.220.2]:34239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759049AbYFNANF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:13:05 -0400
Date: Fri, 13 Jun 2008 17:10:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 13/47] sunhv: Fix locking in non-paged I/O case.
Message-ID: <20080614001049.GM24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sunhv-fix-locking-in-non-paged-i-o-case.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ upstream commit: 3651751fff44ede58f65cbb1e39242139ead251b ]

This causes the lock to be taken twice, thus resulting in
a deadlock.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/serial/sunhv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -499,7 +499,6 @@ static void sunhv_console_write_bychar(s
 	} else
 		spin_lock(&port->lock);
 
-	spin_lock_irqsave(&port->lock, flags);
 	for (i = 0; i < n; i++) {
 		if (*s == '\n')
 			sunhv_console_putchar(port, '\r');

-- 
