Return-Path: <linux-kernel-owner+w=401wt.eu-S1751319AbZCINnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbZCINnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZCINnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:43:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZCINnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:43:01 -0400
Subject: [PATCH] x86: suggest running a 64bit kernel on LM capable machines
 with plenty memory.
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <87r617ojfi.fsf@firstfloor.org>
References: <49B254C6.8010507@pardus.org.tr>
	 <20090307193026.GA2165@x200.localdomain> <49B2CE44.4060305@pardus.org.tr>
	 <87r617ojfi.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Mar 2009 14:42:48 +0100
Message-Id: <1236606168.8389.512.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 8bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 21:20 +0100, Andi Kleen wrote:
> Ozan Çağlayan <ozan@pardus.org.tr> writes:
> >
> > So, the PAE enabled kernel should be installed by distribution installers or
> > package management systems if the processor honors the PAE bit. Because PAE
> > is an extension mechanism for 32bit processors, AFAIK it has some overhead.
> > So enabling it if the user doesn't have a memory size >=4GB would not make
> > much sense if a proper noexecute (NX) support is not intended.
> 
> The general recommendation is to always use PAE when the machine 
> is NX capable. Or at least use it by default.

How about we do the below as well?

---
If the hardware is capable, its much better to run a 64bit kernel than a
32bit PAE kernel with lots of memory.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/mm/init_32.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 34ef5c7..3d22baa 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -714,6 +714,9 @@ void __init lowmem_pfn_init(void)
 
 #define MSG_HIGHMEM_TRIMMED \
 	"Warning: only 4GB will be used. Use a HIGHMEM64G enabled kernel!\n"
+
+#define MSG_LM_TRIMMED \
+	"Warning: instead of using a 32bit PAE kernel, Use a 64bit kernel!\n"
 /*
  * We have more RAM than fits into lowmem - we try to put it into
  * highmem, also taking the highmem=x boot parameter into account:
@@ -750,6 +753,8 @@ void __init highmem_pfn_init(void)
 	}
 #endif /* !CONFIG_HIGHMEM64G */
 #endif /* !CONFIG_HIGHMEM */
+	if (boot_cpu_has(X86_FEATURE_LM))
+		printk(KERN_WARNING MSG_LM_TRIMMED);
 }
 
 /*


