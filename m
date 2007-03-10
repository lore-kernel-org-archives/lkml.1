Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbXCJGYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbXCJGYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXCJGTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:19:33 -0500
Received: from mail.suse.de ([195.135.220.2]:41035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbXCJGT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:19:27 -0500
Date: Fri, 9 Mar 2007 22:17:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, netfilter-devel@lists.netfilter.org,
       Patrick McHardy <kaber@trash.net>, davem@davemloft.net
Subject: [patch 10/20] nfnetlink_log: zero-terminate prefix
Message-ID: <20070310061748.GK31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfnetlink_log-zero-terminate-prefix.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: nfnetlink_log: zero-terminate prefix

Userspace expects a zero-terminated string, so include the trailing
zero in the netlink message.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nfnetlink_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -620,7 +620,7 @@ nfulnl_log_packet(unsigned int pf,
 
 	plen = 0;
 	if (prefix)
-		plen = strlen(prefix);
+		plen = strlen(prefix) + 1;
 
 	/* all macros expand to constant values at compile time */
 	/* FIXME: do we want to make the size calculation conditional based on

-- 
