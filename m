Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbYEMUSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbYEMUSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762167AbYEMUOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:14:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:38325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762161AbYEMUOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:14:46 -0400
Date: Tue, 13 May 2008 13:12:09 -0700
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
       Chris Wright <chrisw@sous-sol.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 16/37] dccp: return -EINVAL on invalid feature length
Message-ID: <20080513201209.GQ31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dccp-return-einval-on-invalid-feature-length.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Chris Wright <chrisw@sous-sol.org>

[ Upstream commit: 19443178fbfbf40db15c86012fc37df1a44ab857 ]

dccp_feat_change() validates length and on error is returning 1.
This happens to work since call chain is checking for 0 == success,
but this is returned to userspace, so make it a real error value.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/dccp/feat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -32,7 +32,7 @@ int dccp_feat_change(struct dccp_minisoc
 
 	if (len > 3) {
 		DCCP_WARN("invalid length %d\n", len);
-		return 1;
+		return -EINVAL;
 	}
 	/* XXX add further sanity checks */
 

-- 
