Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZA2Bxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZA2Bxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbZA2Bxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:53:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:29548 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbZA2Bxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:53:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,340,1231142400"; 
   d="scan'208";a="104847501"
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old
	subarchitecture code
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 28 Jan 2009 17:52:57 -0800
Message-Id: <1233193977.15801.72.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 15:41 -0800, Ingo Molnar wrote:
> This series of 114 patches implements a long desired restructuring,
> unification and cleanup of the x86 APIC/SMP/subarch code:
> 
>   - unifies the 32-bit and 64-bit genapic code
> 
>   - sorts out all the subarch details into standalone and boot-time
>     probable quirk modules
> 
>   - removes the build-time subarch hacks that we had on 32-bit.
> 
> This inevitably touches an awful lot of x86 code, and rather intrusively
> so:
> 
>     112 files changed, 3277 insertions(+), 3209 deletions(-)
> 
> So breakages are to be expected. 

Here's one :)

diff --git a/arch/x86/include/asm/genapic.h
b/arch/x86/include/asm/genapic.h
index 4bbcf26..273b994 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -145,7 +145,7 @@ static inline unsigned int read_apic_id(void)
 {
 	unsigned int reg;
 
-	reg = *(u32 *)(APIC_BASE + APIC_ID);
+	reg = apic_read(APIC_ID);
 
 	return apic->get_apic_id(reg);
 }


