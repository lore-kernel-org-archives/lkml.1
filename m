Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZGEQCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZGEQCD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZGEQBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:01:55 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64016 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZGEQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=t3RaLRkHJqoBrYCB6Hv+zO2fDFOW/HBbpIPXXD2XwsAyftyGm/EFK39wQ1lc2JdW0H
         otRZ/om45lXyFe4j5rfNsv32ob5oQcS5wfRQVhNZ1IvXfssBeYzJwCkN1SLhrMAu/+IF
         slT2i4cTK1AqEeugstv67p6qmycBkY5TDhAYA=
Date: Sun, 5 Jul 2009 20:01:54 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86,ipi - use cpu_has_apic macro helper
Message-ID: <20090705160154.GB4791@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already use a lot of cpu_has_ helpers.
Lets do here the same for consistency.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/ipi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/apic/ipi.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/ipi.c
+++ linux-2.6.git/arch/x86/kernel/apic/ipi.c
@@ -150,7 +150,7 @@ int safe_smp_processor_id(void)
 {
 	int apicid, cpuid;
 
-	if (!boot_cpu_has(X86_FEATURE_APIC))
+	if (!cpu_has_apic)
 		return 0;
 
 	apicid = hard_smp_processor_id();
