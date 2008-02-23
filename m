Return-Path: <linux-kernel-owner+w=401wt.eu-S936674AbYBWAi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936674AbYBWAi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934549AbYBWAeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:34:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934454AbYBWAeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:34:13 -0500
Date: Fri, 22 Feb 2008 16:30:20 -0800
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
       Paul Moore <paul.moore@hp.com>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/38] SELinux: Fix double free in
	selinux_netlbl_sock_setsid()
Message-ID: <20080223003020.GM7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="selinux-fix-double-free-in-selinux_netlbl_sock_setsid.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
Upstream commit: e1770d97a730ff4c3aa1775d98f4d0558390607f

As pointed out by Adrian Bunk, commit
45c950e0f839fded922ebc0bfd59b1081cc71b70 ("fix memory leak in netlabel
code") caused a double-free when security_netlbl_sid_to_secattr()
fails.  This patch fixes this by removing the netlbl_secattr_destroy()
call from that function since we are already releasing the secattr
memory in selinux_netlbl_sock_setsid().

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/ss/services.c |    1 -
 1 file changed, 1 deletion(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2629,7 +2629,6 @@ int security_netlbl_sid_to_secattr(u32 s
 
 netlbl_sid_to_secattr_failure:
 	POLICY_RDUNLOCK;
-	netlbl_secattr_destroy(secattr);
 	return rc;
 }
 #endif /* CONFIG_NETLABEL */

-- 
