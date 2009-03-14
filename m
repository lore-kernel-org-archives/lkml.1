Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZCNAT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZCNAT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZCNASY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:24 -0400
Received: from kroah.org ([198.145.64.141]:46593 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752113AbZCNASX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:39 2009
Message-Id: <20090314000739.054030597@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:11 -0700
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
       alan@lxorguk.ukuu.org.uk, Eugene Teo <eugeneteo@kernel.sg>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/96] net: amend the fix for SO_BSDCOMPAT gsopt infoleak
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=net-amend-the-fix-for-so_bsdcompat-gsopt-infoleak.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eugene Teo <eugeneteo@kernel.sg>

[ Upstream commit 50fee1dec5d71b8a14c1b82f2f42e16adc227f8b ]

The fix for CVE-2009-0676 (upstream commit df0bca04) is incomplete. Note
that the same problem of leaking kernel memory will reappear if someone
on some architecture uses struct timeval with some internal padding (for
example tv_sec 64-bit and tv_usec 32-bit) --- then, you are going to
leak the padded bytes to userspace.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -695,7 +695,7 @@ int sock_getsockopt(struct socket *sock,
 	if (len < 0)
 		return -EINVAL;
 
-	v.val = 0;
+	memset(&v, 0, sizeof(v));
 
 	switch(optname) {
 	case SO_DEBUG:


