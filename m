Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZC2Gqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZC2Gqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 02:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZC2GqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 02:46:19 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:42789 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZC2GqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 02:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i+5Sj2UEFLzbQBOkFaP/Ql3BTaYAE5xi9qxFr8XToAelrHHJFLNCrpW3cu0dGGWxPW
         Xbr2FvdvW0i4YJTYIGSNWxo91IqgxIbkAGvHDEQ84mcWtXt0dSfK1G3s4qTSIQSTaEJZ
         OJvcPk49txs7S11hrxh0k50/ivzfW4uU7eeZw=
Date: Sun, 29 Mar 2009 10:47:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kaber@trash.net,
       netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for March 27 (netfilter build error)
Message-ID: <20090329064704.GA7255@localhost>
References: <20090327231924.4e4168c5.sfr@canb.auug.org.au> <49CD0368.2010805@oracle.com> <20090327.160107.184169637.davem@davemloft.net> <20090328102852.GA7697@localhost> <49CEF882.5000005@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CEF882.5000005@oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Randy Dunlap - Sat, Mar 28, 2009 at 09:26:42PM -0700]
... 
| works_for_me.  Thanks.
| but missing S-O-B.
| 
| Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
...

Thanks for testing Randy. So if nobody will complain
here is a solid version of the patch. Though I would like
if Pablo or Patrick confirm its correctness. Thanks!

       Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: netfilter: xtables - build issue fix

Randy Dunlap reported:
| with CONFIG_IPV6=n:
|
| ERROR: "__ipv6_addr_type" [net/netfilter/xt_cluster.ko] undefined!

ipv6_addr_type does depend on IPv6 being tuned on.
Guard it with CONFIG_IPV6/_MODULE.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/netfilter/xt_cluster.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.git/net/netfilter/xt_cluster.c
===================================================================
--- linux-2.6.git.orig/net/netfilter/xt_cluster.c
+++ linux-2.6.git/net/netfilter/xt_cluster.c
@@ -67,8 +67,10 @@ xt_cluster_is_multicast_addr(const struc
 		is_multicast = ipv4_is_multicast(ip_hdr(skb)->daddr);
 		break;
 	case NFPROTO_IPV6:
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 		is_multicast = ipv6_addr_type(&ipv6_hdr(skb)->daddr) &
 						IPV6_ADDR_MULTICAST;
+#endif
 		break;
 	default:
 		WARN_ON(1);
