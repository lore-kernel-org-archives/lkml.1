Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbXJCJNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbXJCJNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbXJCJNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:13:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52927 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbXJCJNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:13:12 -0400
Date: Wed, 3 Oct 2007 11:12:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux
	2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Message-ID: <20071003091257.GA15815@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <20071003084607.GC32218@elte.hu> <20071003085022.GA6672@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003085022.GA6672@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  nodev /debug debugfs rw 0 0
>  ) = 290
>  read(3, "", 4096)                       = 0
>  close(3)                                = 0
> 
> there's nothing particularly interesting in it. (perhaps debugfs)

disabling debugfs makes the crash go away so it's debugfs related. The 
.config delta is below.

	Ingo

--- .config.broken.000	2007-10-03 10:28:14.000000000 +0200
+++ .config.good.000	2007-10-03 11:11:18.000000000 +0200
@@ -85,7 +85,7 @@ CONFIG_MODULE_SRCVERSION_ALL=y
 # CONFIG_KMOD is not set
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
-CONFIG_BLK_DEV_IO_TRACE=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
 CONFIG_LSF=y
 CONFIG_BLK_DEV_BSG=y
 
@@ -631,7 +631,6 @@ CONFIG_CFG80211=y
 CONFIG_WIRELESS_EXT=y
 CONFIG_MAC80211=y
 CONFIG_MAC80211_LEDS=y
-CONFIG_MAC80211_DEBUGFS=y
 # CONFIG_MAC80211_DEBUG is not set
 CONFIG_IEEE80211=m
 CONFIG_IEEE80211_DEBUG=y
@@ -1689,7 +1688,7 @@ CONFIG_TRACE_IRQFLAGS_SUPPORT=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 CONFIG_UNUSED_SYMBOLS=y
-CONFIG_DEBUG_FS=y
+# CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_SHIRQ=y
@@ -1724,8 +1724,6 @@ CONFIG_FAULT_INJECTION=y
 # CONFIG_FAILSLAB is not set
 CONFIG_FAIL_PAGE_ALLOC=y
 CONFIG_FAIL_MAKE_REQUEST=y
-CONFIG_FAULT_INJECTION_DEBUG_FS=y
-CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
 CONFIG_EARLY_PRINTK=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 # CONFIG_DEBUG_STACK_USAGE is not set
