Return-Path: <linux-kernel-owner+w=401wt.eu-S936567AbZLQEbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936567AbZLQEbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935337AbZLQEEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:39 -0500
Received: from kroah.org ([198.145.64.141]:55606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935643AbZLQEEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:33 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:52 2009
Message-Id: <20091217035651.948970563@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>
Subject: [070/151] x86: Fix bogus warning in apic_noop.apic_write()
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit a946d8f11f0da9cfc714248036fcfd3a794d1e27 upstream.

apic_noop is used to provide dummy apic functions. It's installed
when the CPU has no APIC or when the APIC is disabled on the kernel
command line.

The apic_noop implementation of apic_write() warns when the CPU has
an APIC or when the APIC is not disabled.

That's bogus. The warning should only happen when the CPU has an
APIC _AND_ the APIC is not disabled. apic_noop.apic_read() has the
correct check.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -246,7 +246,7 @@ static int modern_apic(void)
  */
 static void native_apic_write_dummy(u32 reg, u32 v)
 {
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
 }
 
 static u32 native_apic_read_dummy(u32 reg)


