Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYAVSz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYAVSz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYAVSzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:55:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYAVSzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:55:18 -0500
Date: Tue, 22 Jan 2008 16:50:18 -0200
From: Eduardo Pereira Habkost <ehabkost@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com, mtosatti@redhat.com
Subject: [PATCH 1/2] Allow enabling PARAVIRT without any guest
	implementation
Message-ID: <20080122185018.GY7338@blackpad>
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com> <20080122120207.GA30271@elte.hu> <20080122123450.GU7338@blackpad> <47962E1D.2090308@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47962E1D.2090308@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Jan 22, 2008 at 09:55:41AM -0800, Jeremy Fitzhardinge wrote:
> Eduardo Pereira Habkost wrote:
> >If this is desirable for broader testing, we can make config PARAVIRT
> >visible and selectable on menuconfig, even when there is no guest
> >implementation being enabled. Should I do it?
> >  
> 
> Yes please.
> 

This will allow people to enable the paravirt_ops code even when no
guest support is enabled, for broader testing of the paravirt_ops code.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/Kconfig |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4e910d8..715bbcd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -325,15 +325,6 @@ config SCHED_NO_NO_OMIT_FRAME_POINTER
 
 	  If in doubt, say "Y".
 
-config PARAVIRT
-	bool
-	depends on X86_32 && !(X86_VISWS || X86_VOYAGER)
-	help
-	  This changes the kernel so it can modify itself when it is run
-	  under a hypervisor, potentially improving performance significantly
-	  over full virtualization.  However, when run without a hypervisor
-	  the kernel is theoretically slower and slightly larger.
-
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
 	depends on X86_32
@@ -359,6 +350,15 @@ config VMI
 
 source "arch/x86/lguest/Kconfig"
 
+config PARAVIRT
+	bool "Enable paravirtualization code"
+	depends on X86_32 && !(X86_VISWS || X86_VOYAGER)
+	help
+	  This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.  However, when run without a hypervisor
+	  the kernel is theoretically slower and slightly larger.
+
 endif
 
 config ACPI_SRAT
-- 
1.5.3.4

-- 
Eduardo
