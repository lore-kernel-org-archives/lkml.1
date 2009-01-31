Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZAaHRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZAaHRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 02:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZAaHRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 02:17:25 -0500
Received: from gw.goop.org ([64.81.55.164]:40920 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbZAaHRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 02:17:24 -0500
Message-ID: <4983FB03.9030001@goop.org>
Date: Fri, 30 Jan 2009 23:17:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: [PATCH 1/2] x86/paravirt: don't restore second return reg
References: <patchbomb.1233182100@abulafia.goop.org> <49815764.6040809@kernel.org> <49817C26.2020503@goop.org> <4983DBC9.5080701@kernel.org>
In-Reply-To: <4983DBC9.5080701@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bugfix

In the 32-bit calling convention, %eax:%edx is used to return 64-bit
values.  Don't save and restore %edx around wrapped functions, or they
can't return a full 64-bit result.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1522,8 +1522,8 @@
 #define PV_RESTORE_REGS "popl %edx; popl %ecx;"
 
 /* save and restore all caller-save registers, except return value */
-#define PV_SAVE_ALL_CALLER_REGS PV_SAVE_REGS
-#define PV_RESTORE_ALL_CALLER_REGS PV_RESTORE_REGS
+#define PV_SAVE_ALL_CALLER_REGS		"pushl %ecx;"
+#define PV_RESTORE_ALL_CALLER_REGS	"popl  %ecx;"
 
 #define PV_FLAGS_ARG "0"
 #define PV_EXTRA_CLOBBERS


