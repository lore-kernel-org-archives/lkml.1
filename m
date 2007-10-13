Return-Path: <linux-kernel-owner+w=401wt.eu-S1761517AbXJMBW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbXJMBW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 21:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759483AbXJMBWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 21:22:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759567AbXJMBWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 21:22:48 -0400
Date: Fri, 12 Oct 2007 21:22:44 -0400
From: Dave Jones <davej@redhat.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current Linus' git compilation breakage.
Message-ID: <20071013012244.GD18760@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	LKML <linux-kernel@vger.kernel.org>
References: <200710131111.32941.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710131111.32941.nigel@nigel.suspend2.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 11:11:31AM +1000, Nigel Cunningham wrote:
 > Hi all.
 > 
 > Maybe I just picked a bad time to try, but...
 > 
 > arch/x86/kernel/alternative.c: In function 'apply_alternatives':
 > arch/x86/kernel/alternative.c:191: error: 'VSYSCALL_START' undeclared (first use in this function)
 > arch/x86/kernel/alternative.c:191: error: (Each undeclared identifier is reported only once
 > arch/x86/kernel/alternative.c:191: error: for each function it appears in.)
 > arch/x86/kernel/alternative.c:191: error: 'VSYSCALL_END' undeclared (first use in this function)
 > make[1]: *** [arch/x86/kernel/alternative.o] Error 1
 > make: *** [arch/x86/kernel] Error 2

Try this.

Include missing header for vsyscall.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index bd72d94..11b03d3 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -10,6 +10,7 @@
 #include <asm/pgtable.h>
 #include <asm/mce.h>
 #include <asm/nmi.h>
+#include <asm/vsyscall.h>
 
 #define MAX_PATCH_LEN (255-1)
 
-- 
http://www.codemonkey.org.uk
