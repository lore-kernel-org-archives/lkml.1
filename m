Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbYJJNwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbYJJNwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbYJJNvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:51:53 -0400
Received: from stinky.trash.net ([213.144.137.162]:54951 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbYJJNvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:51:52 -0400
Message-ID: <48EF5DF5.7070708@trash.net>
Date: Fri, 10 Oct 2008 15:51:49 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Nir Tzachar <nir.tzachar@gmail.com>
CC: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89 nf_nat_fn+0x33/0x155()
References: <9b2db90b0810092324o729e29c0i2e654c812592bbd2@mail.gmail.com>
In-Reply-To: <9b2db90b0810092324o729e29c0i2e654c812592bbd2@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040401060501090200000002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040401060501090200000002
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Nir Tzachar wrote:
> Hello.
> 
> The following warning is reproducible with the code below on 2.6.25.6,
> which uses sendmsg on a udp socket using two iovecs:
> 
> ....
> And I always get  the following warning twice:
> 
> [ 6658.338116] ------------[ cut here ]------------
> [ 6658.338121] WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89
> nf_nat_fn+0x33/0x155()

Thanks for the report. Does this patch fix it?


--------------040401060501090200000002
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 5a955c4..5bd4833 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -92,7 +92,7 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 
 	/* Conntrack defragments packets, we might still see fragments
 	 * inside ICMP packets though. */
-	if (iph->frag_off & htons(IP_OFFSET))
+	if (iph->frag_off & htons(IP_MF | IP_OFFSET))
 		return -NF_DROP;
 
 	*dataoff = nhoff + (iph->ihl << 2);

--------------040401060501090200000002--
