Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbZGVUxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbZGVUxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZGVUxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:53:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:64741 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbZGVUxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jR8z7cURHahEG9etzkf0Jrpssab+9WcdZzS8jJWeiwy0rIac+KjV/E0bAj/nmlQRQ7
         isTQeNv78YGZycwx+JO7ua++0cnESXRtoMgXkvi4X+Al3hoWzujywnBmp+LnDKk0/lq4
         NRJYPD5mySlIAUBdX/z/+CjZe5pqeL89TmoDQ=
Date: Thu, 23 Jul 2009 00:52:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86,apic - drop redundant bit assignment
Message-ID: <20090722205259.GE15805@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_has_apic has already investigated boot_cpu_data
X86_FEATURE_APIC bit for being clear if condition
is triggered. So there is no need to clear this bit
second time.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review. Is there some unobvious reason was before
to clear this bit? This snippet already here since long ago.
Perhaps I miss something?

 arch/x86/kernel/apic/apic.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -1651,7 +1651,6 @@ int __init APIC_init_uniprocessor(void)
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
 		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
 			boot_cpu_physical_apicid);
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
 #endif
