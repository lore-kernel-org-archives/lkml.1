Return-Path: <linux-kernel-owner+w=401wt.eu-S965606AbXCGRW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606AbXCGRW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422926AbXCGRSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:18:37 -0500
Received: from mail.suse.de ([195.135.220.2]:44453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422910AbXCGRSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:18 -0500
Message-Id: <20070307171641.137740642@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       caglar@pardus.org.tr, mingo@elte.hu, avi@qumranet.com
Subject: [patch 092/101] kvm: Fix asm constraint for lldt instruction
Content-Disposition: inline; filename=kvm-fix-asm-constraint-for-lldt-instruction.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: S.Caglar Onur <caglar@pardus.org.tr>

lldt does not accept immediate operands, which "g" allows.

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/kvm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/drivers/kvm/kvm.h
+++ linux-2.6.20.1/drivers/kvm/kvm.h
@@ -558,7 +558,7 @@ static inline void load_gs(u16 sel)
 #ifndef load_ldt
 static inline void load_ldt(u16 sel)
 {
-	asm ("lldt %0" : : "g"(sel));
+	asm ("lldt %0" : : "rm"(sel));
 }
 #endif
 

--
