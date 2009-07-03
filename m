Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZGCIMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZGCIMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZGCIMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:12:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34351 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZGCIMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:12:20 -0400
Date: Fri, 3 Jul 2009 10:12:19 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, htejun@gmail.com, jarkao2@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org, eric.dumazet@gmail.com
Subject: [PATCHv5 0/2] net: fix race in the receive/select
Message-ID: <20090703081219.GE2902@jolsa.lab.eng.brq.redhat.com>
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

Patchset is made on top of Linus'es tree 7c5371c403abb29f01bc6cff6c5096abdf2dc524 .

Booted on x86_64.

wbr,
jirka

---
 arch/x86/include/asm/spinlock.h |    3 ++
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
 12 files changed, 96 insertions(+), 19 deletions(-)
