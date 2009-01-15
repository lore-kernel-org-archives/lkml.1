Return-Path: <linux-kernel-owner+w=401wt.eu-S934874AbZAOWMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874AbZAOWMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933590AbZAOWCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:12 -0500
Received: from kroah.org ([198.145.64.141]:38225 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933550AbZAOWCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:06 -0500
Date: Thu, 15 Jan 2009 13:59:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ravikiran Thirumalai <kiran@scalex86.org>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 18/85] x86: fix incorrect __read_mostly on _boot_cpu_pda
Message-ID: <20090115215930.GS17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-incorrect-__read_mostly-on-_boot_cpu_pda.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ravikiran G Thirumalai <kiran@scalex86.org>

commit 26799a63110dcbe81291ea53178f6b4810d07424 upstream.

The pda rework (commit 3461b0af025251bbc6b3d56c821c6ac2de6f7209)
to remove static boot cpu pdas introduced a performance bug.

_boot_cpu_pda is the actual pda used by the boot cpu and is definitely
not "__read_mostly" and ended up polluting the read mostly section with
writes.  This bug caused regression of about 8-10% on certain syscall
intensive workloads.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Acked-by: Mike Travis <travis@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/head64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -26,7 +26,7 @@
 #include <asm/bios_ebda.h>
 
 /* boot cpu pda */
-static struct x8664_pda _boot_cpu_pda __read_mostly;
+static struct x8664_pda _boot_cpu_pda;
 
 #ifdef CONFIG_SMP
 /*

