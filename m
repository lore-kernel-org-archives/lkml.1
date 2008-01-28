Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbYA1XC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbYA1XC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760621AbYA1XCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:02:03 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:50982 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761353AbYA1XB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:01:59 -0500
Message-ID: <479E5ECF.2000302@web.de>
Date: Tue, 29 Jan 2008 00:01:35 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH] KGDB: refactor kconfig menu
References: <479CA7CE.8040407@web.de> <479E5C18.4010809@web.de>
In-Reply-To: <479E5C18.4010809@web.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19dFAeMtGNtgDT+z8OY7nul+EdH8puq9ZKpk5rN
	nYMcdOX0u+/lRDEZSci6YeOHCiEpIRSorJ587zRhQvmmVCQAcd
	ApIZU9//A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> Jan Kiszka wrote:
>> This is an attempt to improve the so far, well, unfortunate Kconfig menu
>> organization of KGDB. Most notably, it pushes all sub-entries into their
>> own menuconfig, removes the (IMHO) unneeded "Method for KGDB
>> communication" choice, and ensures everything is indented properly. This
>> should keep the original semantic while reducing the number of knobs the
>> user is confronted with.
> 
> I realized that KGDB_8250_CONF_STRING is unused in case the driver is
> built as module. So here comes an updated patch that exposes this option
> only when it is actually needed.

Oh, I missed that part one is already in x86.git. So the delta is:


Ask for KGDB_8250_CONF_STRING only in the non-modular case.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 lib/Kconfig.kgdb |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/lib/Kconfig.kgdb
===================================================================
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -55,7 +55,7 @@ config KGDB_PORT_NUM

 config KGDB_8250_CONF_STRING
 	string "Configuration string for KGDB"
-	depends on KGDB_8250 && !KGDB_SIMPLE_SERIAL
+	depends on (KGDB_8250 = y) && !KGDB_SIMPLE_SERIAL
 	default "io,2f8,115200,3" if X86
 	help
 	  The format of this string should be <io or mmio>,
