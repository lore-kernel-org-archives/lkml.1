Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbYLPTnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbYLPTnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYLPTm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:42:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37110 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYLPTm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:42:56 -0500
Date: Sun, 14 Dec 2008 15:03:53 -0500
From: Dave Jones <davej@redhat.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Jan Engelhardt <jengelh@medozas.de>, David Miller <davem@davemloft.net>,
       ajax@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net: Remove a noisy printk
Message-ID: <20081214200353.GA2994@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>, ajax@redhat.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
References: <1229033625-30825-1-git-send-email-ajax@redhat.com> <20081211.203243.124017657.davem@davemloft.net> <alpine.LNX.1.10.0812132310080.27276@fbirervta.pbzchgretzou.qr> <alpine.DEB.2.00.0812141745550.2447@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0812141745550.2447@blackhole.kfki.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 06:09:17PM +0100, Jozsef Kadlecsik wrote:

 > > >> @@ -147,8 +147,6 @@ static unsigned int ipv4_conntrack_local(unsigned int hooknum,
 > > >>  	/* root is playing with raw sockets. */
 > > >>  	if (skb->len < sizeof(struct iphdr) ||
 > > >>  	    ip_hdrlen(skb) < sizeof(struct iphdr)) {
 > > >> -		if (net_ratelimit())
 > > >> -			printk("ipt_hook: happy cracking.\n");
 > > >>  		return NF_ACCEPT;
 > > >>  	}
 > > >>  	return nf_conntrack_in(dev_net(out), PF_INET, hooknum, skb);
 > > 
 > > I think this change is ok.
 > 
 > In a >normal< system one usually does not use raw sockets. So if a root 
 > process do use raw socket, at least netfilter sends a notification and 
 > there's a chance that someone take notice it by checking the kernel logs.

'normal' systems are irrelevant here. This message is triggerable remotely.
Even though it's ratelimited, anyone can flood another boxes logs by
sending enough packets.

The message is also utterly useless. What kind of action would you take
to a few gigabytes of "ipt_hook: happy cracking.\n" ?
There's no IP address logged, or any other useful information.

	Dave

-- 
http://www.codemonkey.org.uk
