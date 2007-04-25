Return-Path: <linux-kernel-owner+w=401wt.eu-S965013AbXDYLvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013AbXDYLvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964780AbXDYLvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:51:14 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:47251 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbXDYLvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:51:13 -0400
Subject: [PATCH 10/10] Use safe_apic_wait_icr_idle in __send_IPI_dest_field
	- x86_64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: horms@verge.net.au, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, ak@suse.de, vgoyal@in.ibm.com,
       mbligh@google.com, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org
In-Reply-To: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 25 Apr 2007 20:51:12 +0900
Message-Id: <1177501872.17974.56.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use safe_apic_wait_icr_idle to check ICR idle bit if the vector is
NMI_VECTOR to avoid potential hangups in the event of crash when kdump
tries to stop the other CPUs.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc7-orig/include/asm-x86_64/ipi.h linux-2.6.21-rc7/include/asm-x86_64/ipi.h
--- linux-2.6.21-rc7-orig/include/asm-x86_64/ipi.h	2007-04-23 17:34:56.000000000 +0900
+++ linux-2.6.21-rc7/include/asm-x86_64/ipi.h	2007-04-25 19:15:01.000000000 +0900
@@ -87,7 +87,10 @@ static inline void __send_IPI_dest_field
 	/*
 	 * Wait for idle.
 	 */
-	apic_wait_icr_idle();
+	if (unlikely(vector == NMI_VECTOR))
+		safe_apic_wait_icr_idle();
+	else
+		apic_wait_icr_idle();
 
 	/*
 	 * prepare target chip field


