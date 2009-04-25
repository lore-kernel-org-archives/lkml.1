Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZDYUbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZDYUbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 16:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZDYUbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 16:31:01 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35660 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZDYUbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 16:31:00 -0400
Date: Sat, 25 Apr 2009 13:30:52 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       paulmck@linux.vnet.ibm.com, Evgeniy Polyakov <zbr@ioremap.net>,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: [PATCH] netfilter: iptables no lockdep is needed..
Message-ID: <20090425133052.4cb711f5@nehalam>
In-Reply-To: <49F22465.80305@gmail.com>
References: <20090418094001.GA2369@ioremap.net>
	<20090418141455.GA7082@linux.vnet.ibm.com>
	<20090420103414.1b4c490f@nehalam>
	<49ECBE0A.7010303@cosmosbay.com>
	<18924.59347.375292.102385@cargo.ozlabs.ibm.com>
	<20090420215827.GK6822@linux.vnet.ibm.com>
	<18924.64032.103954.171918@cargo.ozlabs.ibm.com>
	<20090420160121.268a8226@nehalam>
	<alpine.LFD.2.00.0904210831560.2199@localhost.localdomain>
	<20090421111541.228e977a@nehalam>
	<20090421193924.GA24404@elte.hu>
	<20090421143927.52d7d89d@nehalam>
	<alpine.LFD.2.00.0904220821240.3101@localhost.localdomain>
	<20090423210938.1501507b@nehalam>
	<49F146FF.5050200@cosmosbay.com>
	<20090424091839.6e13ebec@nehalam>
	<49F22465.80305@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Epilogue due to master Jarek. Lockdep carest not about the locking
doth bestowed. Therefore no keys are needed.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
 net/netfilter/x_tables.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/net/netfilter/x_tables.c	2009-04-25 13:25:48.115026283 -0700
+++ b/net/netfilter/x_tables.c	2009-04-25 13:26:15.646215635 -0700
@@ -1145,14 +1145,9 @@ static int __init xt_init(void)
 {
 	unsigned int i;
 	int rv;
-	static struct lock_class_key xt_lock_key[NR_CPUS];
 
-	for_each_possible_cpu(i) {
-		rwlock_t *lock = &per_cpu(xt_info_locks, i);
-
-		rwlock_init(lock);
-		lockdep_set_class(lock, xt_lock_key+i);
-	}
+	for_each_possible_cpu(i)
+		rwlock_init(&per_cpu(xt_info_locks, i));
 
 	xt = kmalloc(sizeof(struct xt_af) * NFPROTO_NUMPROTO, GFP_KERNEL);
 	if (!xt)
