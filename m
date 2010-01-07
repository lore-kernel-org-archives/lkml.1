Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743Ab0AGDqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab0AGDqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730Ab0AGDqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:46:17 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:56626 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0AGDqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:46:16 -0500
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.49,233,1262581200"; 
   d="scan'208";a="9819776"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Kgdb-bugreport] [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
Date: Thu, 7 Jan 2010 11:50:38 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA055F00DD@chinexm1.ad.analog.com>
In-Reply-To: <4B44E7E3.10305@windriver.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Kgdb-bugreport] [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
Thread-Index: AcqPCIndtvYuiWXRRrqSTCJByUo00AAPjdvw
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com><1261603190-5036-4-git-send-email-jason.wessel@windriver.com><1261603190-5036-5-git-send-email-jason.wessel@windriver.com><1261603190-5036-6-git-send-email-jason.wessel@windriver.com><1261603190-5036-7-git-send-email-jason.wessel@windriver.com><1261603190-5036-8-git-send-email-jason.wessel@windriver.com><1261603190-5036-9-git-send-email-jason.wessel@windriver.com><1261603190-5036-10-git-send-email-jason.wessel@windriver.com><8bd0f97a0912261312x4b7c7df6s14ac0137b702044e@mail.gmail.com><0F1B54C89D5F954D8535DB252AF412FA0553E3A0@chinexm1.ad.analog.com> <4e5ebad50912301845p35b1ea98l2f91c2a209ee863a@mail.gmail.com> <4B44E7E3.10305@windriver.com>
To: "Jason Wessel" <jason.wessel@windriver.com>,
       "Sonic Zhang" <sonic.adi@gmail.com>
CC: "Mike Frysinger" <vapier.adi@gmail.com>,
       <kgdb-bugreport@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>
X-OriginalArrivalTime: 07 Jan 2010 03:46:01.0731 (UTC) FILETIME=[EE546D30:01CA8F4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

I tried your latest update of this patch, it works well. So I am OK with
it.

And I will try your generic CPU switch code on blackfin.


Sonic


-----Original Message-----
From: Jason Wessel [mailto:jason.wessel@windriver.com] 
Sent: Thursday, January 07, 2010 3:44 AM
To: Sonic Zhang
Cc: Zhang, Sonic; Mike Frysinger; kgdb-bugreport@lists.sourceforge.net;
linux-kernel@vger.kernel.org; mingo@elte.hu
Subject: Re: [Kgdb-bugreport] [PATCH 09/37] kgdb,blackfin: Add in
kgdb_arch_set_pc for blackfin

Sonic Zhang wrote:
> I have to recall my last wrong patch.
>
> In blackfin, kgdb is running in delayed exception IRQ5 other than in 
> exception IRQ3 directly.  Register reti other than retx in pt_regs is 
> the kgdb return address. So, don't put PC in gdb_regs into retx.
>
> Sonic Zhang
>
> Index: arch/blackfin/kernel/kgdb.c
> ============================
> --- arch/blackfin/kernel/kgdb.c	(revision 8105)
> +++ arch/blackfin/kernel/kgdb.c	(revision 8106)
> @@ -147,7 +147,7 @@
>  	regs->lb1 = gdb_regs[BFIN_LB1];
>  	regs->usp = gdb_regs[BFIN_USP];
>  	regs->syscfg = gdb_regs[BFIN_SYSCFG];
> -	regs->retx = gdb_regs[BFIN_PC];
> +	regs->retx = gdb_regs[BFIN_RETX];
>  	regs->retn = gdb_regs[BFIN_RETN];
>  	regs->rete = gdb_regs[BFIN_RETE];
>  	regs->pc = gdb_regs[BFIN_PC];
>
>   

Sonic,

I pulled in this patch, and made the changes the Mike talked about with
respect to cleaning up the arch specific kgdb.c for blackfin.  See the
attached patch.

Your patch and the one here will go into kgdb-next and onto linux-next.

At some point you sent a patch for cpu switching that was blackfin
specific.  There is new generic code in the debug core for doing this
without exiting the debug context.  At some point you should test this
and figure out if something further needs to be done that is blackfin
specific.

Thanks,
Jason.
