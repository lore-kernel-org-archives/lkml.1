Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbXIUCGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbXIUCGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 22:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXIUCF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 22:05:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:27302 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbXIUCF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 22:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=mzKNGgAuivrZw2TI3ARBEXkMbeobj5ctdJdYbrbZ8L+TkjeGMN2uRYU7xNrNorkeRcRaGuhLwuSFm4yvCgaCbGot8WV4Z3EUi5CB2ozb7KAluXD6c3vqpY9jENgVy5/CxdkGVG7Qls1ga9bdsxXiwjYGjPfucxCxWyVjKsHh1Oo=
Date: Thu, 20 Sep 2007 22:05:54 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] Remove broken netfilter binary sysctls from bridging code
Message-ID: <20070921020554.GE31759@nineveh.local>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The netfilter sysctls in the bridging code don't set strategy routines:

 sysctl table check failed: /net/bridge/bridge-nf-call-arptables .3.10.1 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-call-iptables .3.10.2 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-call-ip6tables .3.10.3 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-filter-vlan-tagged .3.10.4 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-filter-pppoe-tagged .3.10.5 Missing strategy

    These binary sysctls can't work. The binary sysctl numbers of
other netfilter sysctls with this problem are being removed.  These
need to go as well.

Signed-off-by: Joseph Fannin <jfannin@gmail.com>

---

   This *really* needs to be reviewed by someone who knows what this
   is all about.  I've simply extended the removal of netfilter binary
   sysctl numbers so I could load bridge.ko.  I don't particularly
   care if I get attributed for this fix or any of that.

   It Works For Me.

diff -ru linux-2.6.23-rc6-mm1.orig/net/bridge/br_netfilter.c linux-2.6.23-rc6-mm1/net/bridge/br_netfilter.c
--- linux-2.6.23-rc6-mm1.orig/net/bridge/br_netfilter.c	2007-09-19 02:40:49.000000000 -0400
+++ linux-2.6.23-rc6-mm1/net/bridge/br_netfilter.c	2007-09-20 20:31:41.000000000 -0400
@@ -904,7 +904,6 @@
 
 static ctl_table brnf_table[] = {
 	{
-		.ctl_name	= NET_BRIDGE_NF_CALL_ARPTABLES,
 		.procname	= "bridge-nf-call-arptables",
 		.data		= &brnf_call_arptables,
 		.maxlen		= sizeof(int),
@@ -912,7 +911,6 @@
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_CALL_IPTABLES,
 		.procname	= "bridge-nf-call-iptables",
 		.data		= &brnf_call_iptables,
 		.maxlen		= sizeof(int),
@@ -920,7 +918,6 @@
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_CALL_IP6TABLES,
 		.procname	= "bridge-nf-call-ip6tables",
 		.data		= &brnf_call_ip6tables,
 		.maxlen		= sizeof(int),
@@ -928,7 +925,6 @@
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_FILTER_VLAN_TAGGED,
 		.procname	= "bridge-nf-filter-vlan-tagged",
 		.data		= &brnf_filter_vlan_tagged,
 		.maxlen		= sizeof(int),
@@ -936,7 +932,6 @@
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_FILTER_PPPOE_TAGGED,
 		.procname	= "bridge-nf-filter-pppoe-tagged",
 		.data		= &brnf_filter_pppoe_tagged,
 		.maxlen		= sizeof(int),

--
Joseph Fannin
jfannin@gmail.com
