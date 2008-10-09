Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbYJIRoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbYJIRoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbYJIRoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:44:22 -0400
Received: from waste.org ([66.93.16.53]:49023 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420AbYJIRoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:44:21 -0400
Subject: RE: [PATCH] x86: trim ACPI sleep stack buffer
From: Matt Mackall <mpm@selenic.com>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: Len Brown <lenb@kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <4911F71203A09E4D9981D27F9D83085803123361@orsmsx503.amr.corp.intel.com>
References: <1222819957.13453.15.camel@calx>
	 <20081009085649.GC29957@atrey.karlin.mff.cuni.cz>
	 <1223571381.17706.94.camel@calx>
	 <alpine.LFD.1.10.0810091319160.3007@localhost.localdomain>
	 <4911F71203A09E4D9981D27F9D83085803123361@orsmsx503.amr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 12:41:50 -0500
Message-Id: <1223574110.17706.109.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 10:23 -0700, Moore, Robert wrote:
> Sounds like you need a
> 
> #define DEFAULT_STACK_SIZE 4096
> 
> Somewhere.

Or maybe something like this:


x86: remove magic number from ACPI sleep stack buffer

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 375a00b8bf10 arch/x86/kernel/acpi/sleep.c
--- a/arch/x86/kernel/acpi/sleep.c	Thu Oct 09 12:38:55 2008 -0500
+++ b/arch/x86/kernel/acpi/sleep.c	Thu Oct 09 12:40:10 2008 -0500
@@ -97,7 +97,7 @@
 #else /* CONFIG_64BIT */
 	header->trampoline_segment = setup_trampoline() >> 4;
 #ifdef CONFIG_SMP
-	stack_start.sp = temp_stack + 4096;
+	stack_start.sp = temp_stack + sizeof(temp_stack);
 #endif
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;


-- 
Mathematics is the supreme nostalgia of our time.

