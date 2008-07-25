Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYGYXNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYGYXNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbYGYXMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:12:55 -0400
Received: from mail.suse.de ([195.135.220.2]:58453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbYGYXMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:12:54 -0400
Date: Fri, 25 Jul 2008 16:07:33 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 7/9] raw: Restore /proc/net/raw correct behavior
Message-ID: <20080725230733.GH1612@suse.de>
References: <20080725225425.193966072@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0007-raw-Restore-proc-net-raw-correct-behavior.patch"
In-Reply-To: <20080725230644.GA1612@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Eric Dumazet <dada1@cosmosbay.com>

[ Upstream commit 68be802cd5ad040fe8cfa33ce3031405df2d9117 ]

I just noticed "cat /proc/net/raw" was buggy, missing '\n' separators.

I believe this was introduced by commit 8cd850efa4948d57a2ed836911cfd1ab299e89c6
([RAW]: Cleanup IPv4 raw_seq_show.)

This trivial patch restores correct behavior, and applies to current
Linus tree (should also be applied to stable tree as well.)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/raw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -936,7 +936,7 @@ static void raw_sock_seq_show(struct seq
 	      srcp  = inet->num;
 
 	seq_printf(seq, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %lu %d %p %d",
+		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %lu %d %p %d\n",
 		i, src, srcp, dest, destp, sp->sk_state,
 		atomic_read(&sp->sk_wmem_alloc),
 		atomic_read(&sp->sk_rmem_alloc),

-- 
