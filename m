Return-Path: <linux-kernel-owner+w=401wt.eu-S1422891AbXCGRYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422891AbXCGRYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422900AbXCGRSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:18:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:44485 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422917AbXCGRSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:25 -0500
Message-Id: <20070307171647.525810803@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, sam@ravnborg.org,
       mingo@elte.hu
Subject: [patch 094/101] fix section mismatch warning in lockdep
Content-Disposition: inline; filename=fix-section-mismatch-warning-in-lockdep.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sam Ravnborg <sam@ravnborg.org>

lockdep_init() is marked __init but used in several places
outside __init code. This causes following warnings:
$ scripts/mod/modpost kernel/lockdep.o
WARNING: kernel/built-in.o - Section mismatch: reference to .init.text:lockdep_init from .text.lockdep_init_map after 'lockdep_init_map' (at offset 0x105)
WARNING: kernel/built-in.o - Section mismatch: reference to .init.text:lockdep_init from .text.lockdep_reset_lock after 'lockdep_reset_lock' (at offset 0x35)
WARNING: kernel/built-in.o - Section mismatch: reference to .init.text:lockdep_init from .text.__lock_acquire after '__lock_acquire' (at offset 0xb2)

The warnings are less obviously due to heavy inlining by gcc - this is not
altered.

Fix the section mismatch warnings by removing the __init marking, which
seems obviously wrong.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/kernel/lockdep.c
+++ linux-2.6.20.1/kernel/lockdep.c
@@ -2577,7 +2577,7 @@ out_restore:
 	raw_local_irq_restore(flags);
 }
 
-void __init lockdep_init(void)
+void lockdep_init(void)
 {
 	int i;
 

--
