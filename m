Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbZABSzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbZABSzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbZABSzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:55:35 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:54700 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbZABSzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:55:35 -0500
Date: Fri, 2 Jan 2009 10:55:24 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, travis@sgi.com, stable@kernel.org,
       shai@scalex86.org
Subject: Re: [patch] x86: Fix incorrect __read_mostly on _boot_cpu_pda
Message-ID: <20090102185524.GB6856@localdomain>
References: <20081231214446.GA6856@localdomain> <20090102160949.GF1180@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <20090102160949.GF1180@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 02, 2009 at 05:09:51PM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> The pda rework (commit 3461b0af025251bbc6b3d56c821c6ac2de6f7209)
>> to remove static boot cpu pdas introduced a bug.  _boot_cpu_pda is the
>> actual pda used by the boot cpu and is definitely not "__read_mostly" and
>> ended up polluting the read mostly section with writes.  This bug caused
>> regression of about 8-10% on certain syscall intensive workloads.
>> 
>> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>
>applied to tip/x86/urgent, with a Cc: stable tag. Thanks,
>

Thanks!

Stable maintainers, please consider this for 2.6.27 stable as well
(in addition to 28).  (Attaching the tip/x86/urgent commit as reference to
the patch)

Thanks,
Kiran

--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=fix_incorrect_readmostly

commit 26799a63110dcbe81291ea53178f6b4810d07424
Author: Ravikiran G Thirumalai <kiran@scalex86.org>
Date:   Wed Dec 31 13:44:46 2008 -0800

    x86: fix incorrect __read_mostly on _boot_cpu_pda
    
    The pda rework (commit 3461b0af025251bbc6b3d56c821c6ac2de6f7209)
    to remove static boot cpu pdas introduced a performance bug.
    
    _boot_cpu_pda is the actual pda used by the boot cpu and is definitely
    not "__read_mostly" and ended up polluting the read mostly section with
    writes.  This bug caused regression of about 8-10% on certain syscall
    intensive workloads.
    
    Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
    Acked-by: Mike Travis <travis@sgi.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 388e05a..b9a4d8c 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -27,7 +27,7 @@
 #include <asm/trampoline.h>
 
 /* boot cpu pda */
-static struct x8664_pda _boot_cpu_pda __read_mostly;
+static struct x8664_pda _boot_cpu_pda;
 
 #ifdef CONFIG_SMP
 /*

--p2kqVDKq5asng8Dg--
