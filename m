Return-Path: <linux-kernel-owner+w=401wt.eu-S1765469AbXKOG0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765469AbXKOG0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764867AbXKOGVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:21:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45881 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764849AbXKOGVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:21:52 -0500
Date: Wed, 14 Nov 2007 22:20:18 -0800
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
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 05/23] Fix 9P protocol build
Message-ID: <20071115062018.GF8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-9p-protocol-build.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ingo Molnar <mingo@elte.hu>

patch 092e9d93b3728d484a4e73df9852dc4002cf9923 in mainline.

[9P]: build fix with !CONFIG_SYSCTL

found via make randconfig build testing:

 net/built-in.o: In function `init_p9':
 mod.c:(.init.text+0x3b39): undefined reference to `p9_sysctl_register'
 net/built-in.o: In function `exit_p9':
 mod.c:(.exit.text+0x36b): undefined reference to `p9_sysctl_unregister'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/9p/9p.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -412,6 +412,18 @@ int p9_idpool_check(int id, struct p9_id
 
 int p9_error_init(void);
 int p9_errstr2errno(char *, int);
+
+#ifdef CONFIG_SYSCTL
 int __init p9_sysctl_register(void);
 void __exit p9_sysctl_unregister(void);
+#else
+static inline int p9_sysctl_register(void)
+{
+	return 0;
+}
+static inline void p9_sysctl_unregister(void)
+{
+}
+#endif
+
 #endif /* NET_9P_H */

-- 
