Return-Path: <linux-kernel-owner+w=401wt.eu-S1762835AbZAWBYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835AbZAWBYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbZAWBPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:24 -0500
Received: from kroah.org ([198.145.64.141]:50680 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760240AbZAWBPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:05 -0500
Date: Thu, 22 Jan 2009 17:12:31 -0800
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
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       davem@davemloft.net
Subject: [patch 28/46] netfilter: x_tables: fix match/target revision lookup
Message-ID: <20090123011231.GC19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netfilter-x_tables-fix-match-target-revision-lookup.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

Upstream commit 656caff:

Commit 55b69e91 (netfilter: implement NFPROTO_UNSPEC as a wildcard
for extensions) broke revision probing for matches and targets that
are registered with NFPROTO_UNSPEC.

Fix by continuing the search on the NFPROTO_UNSPEC list if nothing
is found on the af-specific lists.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/x_tables.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -273,6 +273,10 @@ static int match_revfn(u8 af, const char
 				have_rev = 1;
 		}
 	}
+
+	if (af != NFPROTO_UNSPEC && !have_rev)
+		return match_revfn(NFPROTO_UNSPEC, name, revision, bestp);
+
 	return have_rev;
 }
 
@@ -289,6 +293,10 @@ static int target_revfn(u8 af, const cha
 				have_rev = 1;
 		}
 	}
+
+	if (af != NFPROTO_UNSPEC && !have_rev)
+		return target_revfn(NFPROTO_UNSPEC, name, revision, bestp);
+
 	return have_rev;
 }
 

