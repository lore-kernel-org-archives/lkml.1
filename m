Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYIXQbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYIXQbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbYIXQbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:31:11 -0400
Received: from the.earth.li ([217.147.81.2]:60507 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbYIXQbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:31:10 -0400
Date: Wed, 24 Sep 2008 17:31:09 +0100
From: Jonathan McDowell <noodles@earth.li>
To: linux-kernel@vger.kernel.org
Subject: Re: Compile error in v2.6.27-rc7-78-gfb478da [PATCH]
Message-ID: <20080924163109.GA19145@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <48DA07FE.6020002@upcomillas.es> (earth.lists.linux-kernel)
Romano Giannetti wrote:

>    CALL    scripts/checksyscalls.sh
>    CC      init/main.o
>    CC      arch/x86/kernel/process_32.o
> arch/x86/kernel/process_32.c: In function ‘cpu_exit_clear’:
> arch/x86/kernel/process_32.c:91: error: implicit declaration of function 
> ‘c1e_remove_cpu’
> make[1]: *** [arch/x86/kernel/process_32.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> make: *** Waiting for unfinished jobs....

Just hit the same myself; looks like a missing include of <asm/idle.h>

Signed-Off-By: Jonathan McDowell <noodles@earth.li>

-----
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4b3cfdf..66d13d9 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -41,6 +41,7 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
+#include <asm/idle.h>
 #include <asm/io.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
-----

J.

-- 
"Every now and then I get an insane urge to move to Finland." -- Peter
da Silva, The Scary Devil Monastery
