Return-Path: <linux-kernel-owner+w=401wt.eu-S1750954AbZC2E1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbZC2E1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 00:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZC2E1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 00:27:39 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:33376 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZC2E1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 00:27:37 -0400
Message-ID: <49CEF882.5000005@oracle.com>
Date: Sat, 28 Mar 2009 21:26:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kaber@trash.net,
       netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for March 27 (netfilter build error)
References: <20090327231924.4e4168c5.sfr@canb.auug.org.au> <49CD0368.2010805@oracle.com> <20090327.160107.184169637.davem@davemloft.net> <20090328102852.GA7697@localhost>
In-Reply-To: <20090328102852.GA7697@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49CEF89B.0013:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [David Miller - Fri, Mar 27, 2009 at 04:01:07PM -0700]
> | From: Randy Dunlap <randy.dunlap@oracle.com>
> | Date: Fri, 27 Mar 2009 09:48:40 -0700
> | 
> | > Stephen Rothwell wrote:
> | > > Hi all,
> | > > 
> | > > Changes since 20090326:
> | > 
> | > 
> | > with CONFIG_IPV6=n:
> | > 
> | > ERROR: "__ipv6_addr_type" [net/netfilter/xt_cluster.ko] undefined!
> | > 
> | > config attached.
> | 
> | Patrick and netfilter folks, please have a look, thanks!
> | 
> 
> Pablo, seems like something as inlined below is
> missed? (except I doubt about CONFIG_IPV6_MODULE
> here)
> 
>         Cyrill

works_for_me.  Thanks.
but missing S-O-B.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
>  net/netfilter/xt_cluster.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6.git/net/netfilter/xt_cluster.c
> ===================================================================
> --- linux-2.6.git.orig/net/netfilter/xt_cluster.c
> +++ linux-2.6.git/net/netfilter/xt_cluster.c
> @@ -67,8 +67,10 @@ xt_cluster_is_multicast_addr(const struc
>  		is_multicast = ipv4_is_multicast(ip_hdr(skb)->daddr);
>  		break;
>  	case NFPROTO_IPV6:
> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
>  		is_multicast = ipv6_addr_type(&ipv6_hdr(skb)->daddr) &
>  						IPV6_ADDR_MULTICAST;
> +#endif
>  		break;
>  	default:
>  		WARN_ON(1);


-- 
~Randy
