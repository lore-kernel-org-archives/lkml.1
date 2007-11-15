Return-Path: <linux-kernel-owner+w=401wt.eu-S1765677AbXKOG0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765677AbXKOG0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764707AbXKOGV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:21:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45915 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764142AbXKOGV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:21:58 -0500
Date: Wed, 14 Nov 2007 22:20:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Tony Battersby <tonyb@cybernetics.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/23] Fix kernel_accept() return handling.
Message-ID: <20071115062025.GH8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-kernel_accept-return-handling.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

patch fa8705b00aeca19d91a1437b8a5cf865999b28f6 in mainline.

[NET]: sanitize kernel_accept() error path

If kernel_accept() returns an error, it may pass back a pointer to
freed memory (which the caller should ignore).  Make it pass back NULL
instead for better safety.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/socket.c
+++ b/net/socket.c
@@ -2230,6 +2230,7 @@ int kernel_accept(struct socket *sock, s
 	err = sock->ops->accept(sock, *newsock, flags);
 	if (err < 0) {
 		sock_release(*newsock);
+		*newsock = NULL;
 		goto done;
 	}
 

-- 
