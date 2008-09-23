Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbYIWTAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbYIWTAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYIWTAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:00:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:12033 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYIWTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YmprLxOg8B5P50hOaDoMbahoqas5/p1d28zx/1NKCRQZjUU6M+Fioq10ahmN8tnP/M
         nO7Ji1s1OodTN3/GZ6ARPUOqa64kmbO3jBzgJzFI2k3lvZGqVf74mFdRgaiEdsIyaPDA
         nhnTHuqWDLGMkhvs+vId+raYZlpvZ0sLWp+UY=
Date: Tue, 23 Sep 2008 23:00:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080923190002.GE10567@localhost>
References: <20080919123320.GF7222@lenovo> <20080923005737.GA25045@linux-os.sc.intel.com> <20080923011620.GB25045@linux-os.sc.intel.com> <20080923045637.GA7172@localhost> <20080923183411.GD25045@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923183411.GD25045@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Suresh Siddha - Tue, Sep 23, 2008 at 11:34:12AM -0700]
...
| 
| This is too confusing. Please change it to something simple, like:
| 
| 	for (i = 0; i < apic; i++)
| 		kfree(early_ioapic_entries[i]);
| 
| or
| 
| 	for (apic = 0; apic < nr_ioapics; apic++)
| 		kfree(early_ioapic_entries[apic]);
| 
| thanks,
| suresh
| 

Suresh,

what about this one?

		- Cyrill -
---
From: Cyrill Gorcunov <gorcunov@gmail.com>

Clean up obscure for() cycle with straight while() form

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-22 17:42:33.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-23 22:45:58.000000000 +0400
@@ -830,9 +830,8 @@ int save_mask_IO_APIC_setup(void)
 	return 0;
 
 nomem:
-	for (; apic > 0; apic--)
-		kfree(early_ioapic_entries[apic]);
-	kfree(early_ioapic_entries[apic]);
+	while (apic >= 0)
+		kfree(early_ioapic_entries[apic--]);
 	memset(early_ioapic_entries, 0,
 		ARRAY_SIZE(early_ioapic_entries));
 
