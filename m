Return-Path: <linux-kernel-owner+w=401wt.eu-S933863AbYHRTrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbYHRTrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764054AbYHRTmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:42:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:49673 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762860AbYHRTml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:42:41 -0400
Date: Mon, 18 Aug 2008 12:20:51 -0700
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
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 43/49] netfilter: nf_nat_snmp_basic: fix a range check in
	NAT for SNMP
Message-ID: <20080818192051.GR10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netfilter-nf_nat_snmp_basic-fix-a-range-check-in-nat-for-snmp.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

commit 252815b0cfe711001eff0327872209986b36d490 upstream

Fix a range check in netfilter IP NAT for SNMP to always use a big enough size
variable that the compiler won't moan about comparing it to ULONG_MAX/8 on a
64-bit platform.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Eugene Teo <eteo@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/nf_nat_snmp_basic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -438,8 +438,8 @@ static unsigned char asn1_oid_decode(str
 				     unsigned int *len)
 {
 	unsigned long subid;
-	unsigned int  size;
 	unsigned long *optr;
+	size_t size;
 
 	size = eoc - ctx->pointer + 1;
 

-- 
