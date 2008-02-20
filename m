Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbYBTRWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbYBTRWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYBTRWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:22:08 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:38085 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYBTRWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:22:06 -0500
Date: Wed, 20 Feb 2008 09:20:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Avi Kivity <avi@qumranet.com>, mingo <mingo@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [kvm-devel] build #365 issue for v2.6.25-rc2-342-g5d9c4a7
 in ./arch/x86/kvm/kvm.ko
Message-Id: <20080220092008.3f3bd994.randy.dunlap@oracle.com>
In-Reply-To: <47BC3407.20307@qumranet.com>
References: <200802201411.18026.toralf.foerster@gmx.de>
	<47BC3121.8070902@qumranet.com>
	<47BC3407.20307@qumranet.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 16:07:03 +0200 Avi Kivity wrote:

> > Looks like KVM conflicts with CONFIG_VOYAGER...
> >
> 
> Attached patch should fix.
> 
> Subject: x86: disable KVM on Voyager
> 
> Most classic Pentiums don't have hardware virtualization
> extension, and building kvm with voyager generates
> spurious failures.
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>

Might as well extend it for VISWS & NUMAQ:

---
From: Avi Kivity <avi@qumranet.com>

Most classic Pentiums don't have hardware virtualization extension,
and building kvm with Voyager, Visual Workstation, or NUMAQ
generates spurious failures.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.25-rc2-git4.orig/arch/x86/Kconfig
+++ linux-2.6.25-rc2-git4/arch/x86/Kconfig
@@ -21,7 +21,7 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
-	select HAVE_KVM
+	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 
 
 config GENERIC_LOCKBREAK
