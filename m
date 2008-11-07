Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbYKGXau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbYKGXau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYKGXXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:23:23 -0500
Received: from kroah.org ([198.145.64.141]:59438 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753875AbYKGXXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:23:18 -0500
Date: Fri, 7 Nov 2008 15:16:11 -0800
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
       alan@lxorguk.ukuu.org.uk, netfilter-devel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>, davem@davemloft.net,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
Subject: [patch 22/23] netfilter: snmp nat leaks memory in case of failure
Message-ID: <20081107231611.GW1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename="netfilter-snmp-nat-leaks-memory-in-case-of-failure.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081107231457.GA1108@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

netfilter: snmp nat leaks memory in case of failure

Upstream commit 311670f3e:

Signed-off-by: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
 net/ipv4/netfilter/nf_nat_snmp_basic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -742,6 +742,7 @@ static unsigned char snmp_object_decode(
 			*obj = kmalloc(sizeof(struct snmp_object) + len,
 				       GFP_ATOMIC);
 			if (*obj == NULL) {
+				kfree(p);
 				kfree(id);
 				if (net_ratelimit())
 					printk("OOM in bsalg (%d)\n", __LINE__);

-- 
