Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZICJer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZICJer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 05:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZICJeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 05:34:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58106 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbZICJep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 05:34:45 -0400
Date: Thu, 3 Sep 2009 19:34:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <sfi-devel@simplefirmware.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the sfi tree with the tip tree
Message-Id: <20090903193444.e236abdb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the sfi tree got a conflict in
arch/x86/kernel/setup.c between commit
b3f1b617f49447df6c3f5fac9c225aaea8b724ea ("x86: Move get/find_smp_config
to x86_init_ops") from the tip tree and commit
efafc8b213e67ed148a5b53ade29ee7b48af907d ("x86: add arch-specific SFI
support") from the sfi tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/setup.c
index a55f660,d784ea2..0000000
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@@ -984,7 -990,10 +985,9 @@@ void __init setup_arch(char **cmdline_p
  	 * Read APIC and some other early information from ACPI tables.
  	 */
  	acpi_boot_init();
+ 
+ 	sfi_init();
  
 -#if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
  	/*
  	 * get boot-time SMP configuration:
  	 */
