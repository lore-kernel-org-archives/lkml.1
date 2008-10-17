Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbYJQMZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbYJQMZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYJQMZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:25:02 -0400
Received: from mail.us.es ([193.147.175.20]:43128 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753557AbYJQMZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:25:00 -0400
Message-ID: <48F88660.7080204@netfilter.org>
Date: Fri, 17 Oct 2008 14:34:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Patrick McHardy <kaber@trash.net>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT]: Networking
References: <20081015.163817.193700221.davem@davemloft.net> <20081017082138.GA23155@elte.hu> <48F87D3E.5020007@trash.net> <20081017120408.GA20030@elte.hu>
In-Reply-To: <20081017120408.GA20030@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------000706050806010703080304"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000706050806010703080304
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

Ingo Molnar wrote:
> * Patrick McHardy <kaber@trash.net> wrote:
> 
>>> net/netfilter/nf_conntrack_netlink.c:819: warning: ‘enum nf_nat_manip_type’ declared inside parameter list
>>> net/netfilter/nf_conntrack_netlink.c:819: warning: its scope is only this definition or declaration, which is probably not what you want
>>> net/netfilter/nf_conntrack_netlink.c:818: error: parameter 2 (‘manip’) has incomplete type
>> Thanks Ingo. I just sent this patch to Benjamin Herrenschmidt
>> for testing.
> 
> build still fails with the attached config.

This should fix it. I have slightly tested it here with your config.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------000706050806010703080304
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

netfilter: ctnetlink: fix compilation without NAT support

This patch fixes the compilation of ctnetlink when the NAT support
is not enabled.

/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:819: warning: enum nf_nat_manip_type\u2019 declared inside parameter list
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:819: warning: its scope is only this definition or declaration, which is probably not what you want

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2008-10-17 14:15:26.000000000 +0200
+++ net-next-2.6/net/netfilter/nf_conntrack_netlink.c	2008-10-17 14:17:12.000000000 +0200
@@ -814,6 +814,7 @@
 	return err;
 }
 
+#ifdef CONFIG_NF_NAT_NEEDED
 static int
 ctnetlink_parse_nat_setup(struct nf_conn *ct,
 			  enum nf_nat_manip_type manip,
@@ -841,6 +842,7 @@
 
 	return parse_nat_setup(ct, manip, attr);
 }
+#endif
 
 static int
 ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])

--------------000706050806010703080304--
