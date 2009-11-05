Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbZKEOhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbZKEOhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbZKEOhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:37:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57862 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920AbZKEOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:37:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, John Kacur <jkacur@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/5] net: push down BKL into proto ops
Date: Thu,  5 Nov 2009 15:37:25 +0100
Message-Id: <1257431850-20874-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
X-Provags-ID: V01U2FsdGVkX1+woWBUSFpYCnJHULXpz+FQ4x5eVrJZjct85M0
 2m8wAzb74TuYBAPZ9/NwcdlZvqXGFiN+fhwfYGYC0DY1Qj03hh
 n5BFwoJPgdPkEsLWseqJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pushes one more use of the BKL from common code into specific
network protocols by killing off the proto ops wrappers.
This should cause no visible changes on the code but saves a few
kilobytes of object code in allyesconfig.

Arnd Bergmann (5):
  net/appletalk: push down BKL into a atalk_dgram_ops
  net/ipx: push down BKL into a ipx_dgram_ops
  net/irda: push BKL into proto_ops
  net/x25: push BKL usage into x25_proto
  net: kill proto_ops wrapper

 include/linux/net.h |   83 -------------
 net/appletalk/ddp.c |  105 ++++++++++++-----
 net/ipx/af_ipx.c    |   54 +++++++--
 net/irda/af_irda.c  |  331 ++++++++++++++++++++++++++++++++++-----------------
 net/x25/af_x25.c    |   71 +++++++++--
 5 files changed, 407 insertions(+), 237 deletions(-)

