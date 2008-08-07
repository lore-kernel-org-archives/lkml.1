Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYHGUiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYHGUiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYHGUhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:37:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:47973 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYHGUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gOo+iZqbAMHPNe0kSuPFNGiO73dEx2552NlZj81ZVnAobamAcY//Sckt/QLX9mwP8+
         VujO41K9slsbn5dILLaKN8JHUHLT4ZeuGHoKEgscnoevgup+4O6oY3Bc1FA7CtQG4Ydr
         XHacos9yig72FcZ+oIbLXC16PRACh41r19WnI=
Date: Fri, 8 Aug 2008 00:37:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: John Gumb <john.gumb@tandberg.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: OOPS, ip -f inet6 route get fec0::1, linux-2.6.26,
	ip6_route_output, rt6_fill_node+0x175
Message-ID: <20080807203748.GA5196@martell.zuzino.mipt.ru>
References: <9F6ACAE02B6DD040A1E259977622CFDB033590C3@oslexcp1.eu.tandberg.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9F6ACAE02B6DD040A1E259977622CFDB033590C3@oslexcp1.eu.tandberg.int>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 07:00:56PM +0200, John Gumb wrote:
> Scenario: no ipv6 default route set.

> # ip -f inet6 route get fec0::1
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c0369b85>] rt6_fill_node+0x175/0x3b0
> EIP is at rt6_fill_node+0x175/0x3b0
>  ip6_route_output+0x50/0xa0
>  ip6_pol_route_output+0x0/0x20
>  inet6_rtm_getroute+0x16e/0x200
>  inet6_rtm_getroute+0x0/0x200
>  rtnetlink_rcv_msg+0x1b9/0x1f0
>  rtnetlink_rcv_msg+0x0/0x1f0
>  netlink_rcv_skb+0x8d/0xb0
>  rtnetlink_rcv+0x17/0x20
>  netlink_unicast+0x23d/0x270
>  memcpy_fromiovec+0x4a/0x70
>  netlink_sendmsg+0x1c1/0x290
>  sock_sendmsg+0xc5/0xf0
>  autoremove_wake_function+0x0/0x50
>  autoremove_wake_function+0x0/0x50
>  sock_sendmsg+0xc5/0xf0
>  copy_from_user+0x37/0x70
>  verify_iovec+0x2c/0x90
>  sys_sendmsg+0x10a/0x220

0xffffffff80424dd3 is in rt6_fill_node (net/ipv6/route.c:2191).
2186                    } else
2187    #endif
2188                            NLA_PUT_U32(skb, RTA_IIF, iif);
2189            } else if (dst) {
2190                    struct in6_addr saddr_buf;
2191      ====>         if (ipv6_dev_get_saddr(ip6_dst_idev(&rt->u.dst)->dev,
					       ^^^^^^^^^^^^^^^^^^^^^^^^
					       		NULL

2192                                           dst, 0, &saddr_buf) == 0)
2193                            NLA_PUT(skb, RTA_PREFSRC, 16, &saddr_buf);
2194            }

