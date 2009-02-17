Return-Path: <linux-kernel-owner+w=401wt.eu-S1751727AbZBQJja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbZBQJja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbZBQJjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:39:16 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:53298 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZBQJjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:39:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YgagVsvyk0mu8srVKTl/XfVGWR2soG7Qq70A5vGBi0vloYMTdgdzywrKYPl2jxIC2h
         uUp1lyLVpciCf1qxDaFV7HQeVsSKbAr9r29XatCZwLIrimvveS4DOe+Wd4FKmTryKVac
         wM/k+DgmxEDw6SyI4o1rxci7mYgpsnQup2uyc=
Date: Tue, 17 Feb 2009 09:39:08 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Karl Hiramoto <karl@hiramoto.org>, netdev@vger.kernel.org,
       netfilter@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH v2] Re: problem with IPoA (CLIP),  NAT, and VLANS
Message-ID: <20090217093908.GB5341@ff.dom.local>
References: <20090216232016.GA4803@ami.dom.local> <499A7D7D.1090607@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499A7D7D.1090607@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry:
-----------------> take 2: changelog fix only

vlan: Update skb->mac_header in __vlan_put_tag().

After moving mac addresses in __vlan_put_tag() skb->mac_header needs
to be updated.

Reported-by: Karl Hiramoto <karl@hiramoto.org>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

 include/linux/if_vlan.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index f8ff918..e1ff5b1 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -210,6 +210,7 @@ static inline struct sk_buff *__vlan_put_tag(struct sk_buff *skb, u16 vlan_tci)
 
 	/* Move the mac addresses to the beginning of the new header. */
 	memmove(skb->data, skb->data + VLAN_HLEN, 2 * VLAN_ETH_ALEN);
+	skb->mac_header -= VLAN_HLEN;
 
 	/* first, the ethernet type */
 	veth->h_vlan_proto = htons(ETH_P_8021Q);

