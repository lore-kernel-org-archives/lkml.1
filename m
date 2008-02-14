Return-Path: <linux-kernel-owner+w=401wt.eu-S1765650AbYBNPCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765650AbYBNPCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYBNPCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:02:42 -0500
Received: from smtp-in.kfki.hu ([148.6.0.25]:50447 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbYBNPCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:02:40 -0500
Date: Thu, 14 Feb 2008 16:02:29 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Patrick McHardy <kaber@trash.net>, lkml <linux-kernel@vger.kernel.org>,
       Krzysztof Piotr Oledzki <ole@ans.pl>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: cups slow on linux-2.6.24
In-Reply-To: <Pine.LNX.4.64.0802102257420.14442@boston.corp.fedex.com>
Message-ID: <Pine.LNX.4.64.0802141536560.22526@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0802102257420.14442@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 10 Feb 2008, Jeff Chua wrote:

> Please note the lastest git commit is missing one part (which was in Jozsef's
> original patch).

Sorry everyone, that's my fault: the patch I sent for the stable branch 
was correct, however I mistyped a state in the patch for the newest 
git tree - Jeff spotted it, thanks! So here follows the patch against the 
newest git tree which corrects the mistake. Please review and commit.

commit 1177898d185f382f491afaee3cdc752729c74bd2
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Thu Feb 14 15:51:21 2008 +0100

    Mistyped state corrected.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 202d7fa..6256795 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -945,7 +945,7 @@ static int tcp_packet(struct nf_conn *ct,
 
 	ct->proto.tcp.state = new_state;
 	if (old_state != new_state
-	    && new_state == TCP_CONNTRACK_CLOSE)
+	    && new_state == TCP_CONNTRACK_FIN_WAIT)
 		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
 	timeout = ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans
 		  && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
 

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
