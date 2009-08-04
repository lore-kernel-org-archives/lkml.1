Return-Path: <linux-kernel-owner+w=401wt.eu-S932919AbZHDPdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbZHDPdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932890AbZHDPde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:33:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:40026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909AbZHDPdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:33:32 -0400
Date: Tue, 4 Aug 2009 15:32:44 GMT
From: tip-bot for Subrata Modak <subrata@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sachinp@linux.vnet.ibm.com, subrata@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, dhowells@redhat.com, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sachinp@linux.vnet.ibm.com, subrata@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, dhowells@redhat.com, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090721023226.31855.67236.sendpatchset@subratamodak.linux.ibm.com>
References: <20090721023226.31855.67236.sendpatchset@subratamodak.linux.ibm.com>
Subject: [tip:x86/urgent] x86: Work around compilation warning in arch/x86/kernel/apm_32.c
Message-ID: <tip-dc731fbbadf5d65c98fcd6c86472aa286c16458a@git.kernel.org>
Git-Commit-ID: dc731fbbadf5d65c98fcd6c86472aa286c16458a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 15:32:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc731fbbadf5d65c98fcd6c86472aa286c16458a
Gitweb:     http://git.kernel.org/tip/dc731fbbadf5d65c98fcd6c86472aa286c16458a
Author:     Subrata Modak <subrata@linux.vnet.ibm.com>
AuthorDate: Tue, 21 Jul 2009 08:02:27 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:34:23 +0200

x86: Work around compilation warning in arch/x86/kernel/apm_32.c

The following fix was initially inspired by David Howells fix
few days back:

  http://lkml.org/lkml/2009/7/9/109

However, Ingo disapproves such fixes as it's dangerous (it can
hide future, relevant warnings) - in something as
performance-uncritical.

So, initialize 'err' to '0' to work around a GCC false positive
warning:

  http://lkml.org/lkml/2009/7/18/89

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
LKML-Reference: <20090721023226.31855.67236.sendpatchset@subratamodak.linux.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apm_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 79302e9..442b550 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -811,7 +811,7 @@ static int apm_do_idle(void)
 	u8 ret = 0;
 	int idled = 0;
 	int polling;
-	int err;
+	int err = 0;
 
 	polling = !!(current_thread_info()->status & TS_POLLING);
 	if (polling) {
