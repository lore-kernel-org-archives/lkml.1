Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZCZWtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZCZWtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZCZWtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:49:31 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33972 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZCZWta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fIEIG1NeDUfg/mQ+mCBt3VS8vt6UNl8AnDDgKHZTFLBsHmuHUiV3qP/JQkh/ycwEaj
         CnKnRZxqix+o5A8wMbJujjWg/nJQ01MxyaOatm09WJ6/pDMXc7fPIlYYqF5AFhw9Eh4H
         pbaLFvwYGIi7J4ZqhYmBkiqKCuHVlO3GLTI9k=
Date: Fri, 27 Mar 2009 01:49:19 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 2.6.30-git] x86: visws: fix UP build
Message-ID: <20090326224919.GA31233@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/visws_quirks.c: In function 'visws_find_smp_config':
arch/x86/kernel/visws_quirks.c:229: error: 'setup_max_cpus' undeclared

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 arch/x86/kernel/visws_quirks.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index d801d06..f8f41c6 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -226,8 +226,10 @@ static int __init visws_find_smp_config(unsigned int reserve)
 		ncpus = CO_CPU_MAX;
 	}
 
+#ifdef CONFIG_SMP
 	if (ncpus > setup_max_cpus)
 		ncpus = setup_max_cpus;
+#endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	smp_found_config = 1;
