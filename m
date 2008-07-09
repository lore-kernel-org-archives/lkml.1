Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYGILRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYGILRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbYGILQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:16:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39145 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172AbYGILQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:16:53 -0400
Date: Wed, 9 Jul 2008 13:16:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch] power, xen64: fix PM_SLEEP build dependencies (was: Re:
	[PATCH 00 of 55] xen64: implement 64-bit Xen support)
Message-ID: <20080709111621.GA2780@elte.hu>
References: <patchbomb.1215554782@localhost> <20080709111219.GA24874@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709111219.GA24874@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Testing: i've done a trial merge of tip/xen-64bit to tip/master - not 
> pushed out yet. If it holds up in testing i'll put the integration 
> rule into tip/master.
> 
> tip/xen-64bit (which i've just pushed out) can be cleanly git-merged 
> into tip/master, so if you send updates then please send it against 
> such a merged tree - even if tip/master does not have tip/xen-64bit 
> yet. These patches will need at least half a day of testing before i 
> can push them out.

find a build fixlet below, for this config:

  http://redhat.com/~mingo/misc/config-Wed_Jul__9_13_02_55_CEST_2008.bad

Rafael, do you agree with how we now can enable PM_SLEEP without having 
PM enabled? xen64 would like to have that - and it needs the fixlet 
below.

	Ingo

--------------->
commit 9280dc82a739c68945d61c80ba06bef6a9383c87
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 9 13:09:43 2008 +0200

    power, xen64: fix PM_SLEEP build dependencies
    
    fix:
    
    kernel/built-in.o: In function `do_fork':
    : undefined reference to `refrigerator'
    kernel/built-in.o: In function `do_signal_stop':
    signal.c:(.text+0x1b076): undefined reference to `refrigerator'
    kernel/built-in.o: In function `ptrace_stop':
    signal.c:(.text+0x1b285): undefined reference to `refrigerator'
    kernel/built-in.o: In function `get_signal_to_deliver':
    : undefined reference to `refrigerator'
    kernel/built-in.o: In function `worker_thread':
    workqueue.c:(.text+0x212c1): undefined reference to `refrigerator'
    [...]
    
    as CONFIG_PM_SLEEP can now be enabled without CONFIG_PM.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/Makefile b/kernel/Makefile
index 0a05120..6678a60 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_PM) += power/
+obj-$(CONFIG_PM_SLEEP) += power/
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
