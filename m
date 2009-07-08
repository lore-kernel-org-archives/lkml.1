Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbZGHTsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbZGHTsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZGHTr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:47:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42521 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbZGHTr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:47:57 -0400
Date: Wed, 8 Jul 2009 21:47:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: netdev@vger.kernel.org
Cc: eric.dumazet@gmail.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, htejun@gmail.com, jarkao2@gmail.com,
       oleg@redhat.com, davidel@xmailserver.org, davem@davemloft.net
Subject: [PATCHv6 0/2] net: fix race in the receive/select
Message-ID: <20090708194726.GA3196@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixies the race within the poll_wait call and the receive callbacks,
by adding memory barrier.

- 1/2 includes the actual fix
- 2/2 includes optimization for the x86 arch

It is discussed and described in the following discussions:

http://lkml.org/lkml/2009/6/18/124
http://lkml.org/lkml/2009/6/25/188
http://lkml.org/lkml/2009/6/29/216
http://lkml.org/lkml/2009/7/3/68

Patchset is made on top of Linus'es tree 44b572809581d5a10dbe35aa6bf689f32b9c5ad6 .

Booted on x86_64.

wbr,
jirka

---
 arch/x86/include/asm/spinlock.h |    4 ++
 include/linux/spinlock.h        |    5 +++
 include/net/sock.h              |   69 +++++++++++++++++++++++++++++++++++++++
 net/atm/common.c                |    6 ++--
 net/core/datagram.c             |    2 +-
 net/core/sock.c                 |    8 ++--
 net/dccp/output.c               |    2 +-
 net/dccp/proto.c                |    2 +-
 net/ipv4/tcp.c                  |    2 +-
 net/iucv/af_iucv.c              |    4 +-
 net/rxrpc/af_rxrpc.c            |    4 +-
 net/unix/af_unix.c              |    8 ++--
 12 files changed, 97 insertions(+), 19 deletions(-)
