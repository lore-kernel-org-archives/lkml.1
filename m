Return-Path: <linux-kernel-owner+w=401wt.eu-S933535AbXHFUtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535AbXHFUtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbXHFUtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:49:08 -0400
Received: from [12.38.223.190] ([12.38.223.190]:7874 "EHLO
	mail.sw.starentnetworks.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758505AbXHFUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:49:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18103.35121.595637.783369@zeus.sw.starentnetworks.com>
Date: Mon, 6 Aug 2007 16:48:49 -0400
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: David Miller <davem@davemloft.net>,
       lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Srinivas Akkipeddi <sakkiped@starentnetworks.com>
Subject: [PATCH] SCTP: fix IPv4 addr in SCTPv6 accept()/getpeername()
In-Reply-To: <46AF3EE5.2070208@hp.com>
References: <46A8F926.1070606@hp.com>
	<18089.1986.267726.233112@zeus.sw.starentnetworks.com>
	<46A908E4.7080502@hp.com>
	<20070730.172320.115931186.davem@davemloft.net>
	<46AF3EE5.2070208@hp.com>
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


An accept() call on a SCTPv6 socket that returns due to connection of
a IPv4 mapped peer will fill out the 'struct sockaddr' with a zero
IPv6 address instead of the IPv4 mapped address of the peer.

This is due to the v4mapped flag not getting copied into the new
socket on accept().

Signed-off-by: Dave Johnson <djohnson@sw.starentnetworks.com>
Cc: Srinivas Akkipeddi <sakkiped@starentnetworks.com>

===== net/sctp/ipv6.c 1.108 vs edited =====
--- 1.108/net/sctp/ipv6.c	2007-07-05 20:40:15 -04:00
+++ edited/net/sctp/ipv6.c	2007-07-25 16:30:41 -04:00
@@ -641,6 +641,8 @@
 	newsctp6sk = (struct sctp6_sock *)newsk;
 	inet_sk(newsk)->pinet6 = &newsctp6sk->inet6;
 
+	sctp_sk(newsk)->v4mapped = sctp_sk(sk)->v4mapped;
+
 	newinet = inet_sk(newsk);
 	newnp = inet6_sk(newsk);
 

