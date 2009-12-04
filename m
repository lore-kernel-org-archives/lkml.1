Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbZLDIm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbZLDIm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZLDIm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:42:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47555 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbZLDIm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:42:56 -0500
Date: Fri, 4 Dec 2009 19:43:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       William Allen Simpson <william.allen.simpson@gmail.com>,
       David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the sysctl tree with the net tree
Message-Id: <20091204194301.ca77fe40.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next merge of the sysctl tree got a conflict in
net/ipv4/sysctl_net_ipv4.c between commit
519855c508b9a17878c0977a3cdefc09b59b30df ("TCPCT part 1c:
sysctl_tcp_cookie_size, socket option TCP_COOKIE_TRANSACTIONS") from the
net tree and commit f8572d8f2a2ba75408b97dc24ef47c83671795d7 ("sysctl
net: Remove unused binary sysctl code") from the sysctl tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/ipv4/sysctl_net_ipv4.c
index 13f7ab6,3000567..0000000
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@@ -713,15 -569,6 +569,13 @@@ static struct ctl_table ipv4_table[] = 
  		.proc_handler	= proc_dointvec,
  	},
  	{
- 		.ctl_name	= CTL_UNNUMBERED,
 +		.procname	= "tcp_cookie_size",
 +		.data		= &sysctl_tcp_cookie_size,
 +		.maxlen		= sizeof(int),
 +		.mode		= 0644,
 +		.proc_handler	= proc_dointvec
 +	},
 +	{
- 		.ctl_name	= CTL_UNNUMBERED,
  		.procname	= "udp_mem",
  		.data		= &sysctl_udp_mem,
  		.maxlen		= sizeof(sysctl_udp_mem),
