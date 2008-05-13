Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbYEMUO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbYEMUO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761706AbYEMUNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:13:34 -0400
Received: from ns1.suse.de ([195.135.220.2]:37699 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761695AbYEMUNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:13:32 -0400
Date: Tue, 13 May 2008 13:11:42 -0700
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
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 05/37] XFRM: AUDIT: Fix flowlabel text format ambibuity.
Message-ID: <20080513201142.GF31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xfrm-audit-fix-flowlabel-text-format-ambibuity.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

[ Upstream commit: 27a27a2158f4fe56a29458449e880a52ddee3dc4 ]

Flowlabel text format was not correct and thus ambiguous.
For example, 0x00123 or 0x01203 are formatted as 0x123.
This is not what audit tools want.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/xfrm/xfrm_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2093,7 +2093,7 @@ static void xfrm_audit_helper_pktinfo(st
 		iph6 = ipv6_hdr(skb);
 		audit_log_format(audit_buf,
 				 " src=" NIP6_FMT " dst=" NIP6_FMT
-				 " flowlbl=0x%x%x%x",
+				 " flowlbl=0x%x%02x%02x",
 				 NIP6(iph6->saddr),
 				 NIP6(iph6->daddr),
 				 iph6->flow_lbl[0] & 0x0f,

-- 
