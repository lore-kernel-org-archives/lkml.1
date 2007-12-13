Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbXLMGjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbXLMGjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758544AbXLMGhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:37:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56247 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbXLMGhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:37:02 -0500
Date: Wed, 12 Dec 2007 22:34:19 -0800
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
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Li Zefan <lizf@cn.fujitsu.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 07/36] nf_nat: fix memset error
Message-ID: <20071213063419.GH25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nf_nat-fix-memset-error.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Li Zefan <lizf@cn.fujitsu.com>

This patch fixes an incorrect memset in the NAT code, causing
misbehaviour when unloading and reloading the NAT module.
Applies to stable-2.6.22 and stable-2.6.23.

Please apply, thanks.
[NETFILTER]: nf_nat: fix memset error

Upstream commit e0bf9cf15fc30d300b7fbd821c6bc975531fab44

The size passing to memset is the size of a pointer. Fixes
misbehaviour when unloading and reloading the NAT module.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/ipv4/netfilter/nf_nat_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -633,7 +633,7 @@ static int clean_nat(struct nf_conn *i, 
 
 	if (!nat)
 		return 0;
-	memset(nat, 0, sizeof(nat));
+	memset(nat, 0, sizeof(*nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
 }

-- 
