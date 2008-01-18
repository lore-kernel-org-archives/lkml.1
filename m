Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYARJ3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYARJ3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYARJ31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:29:27 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47615 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbYARJ3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:29:25 -0500
Subject: Re: x86: kdump failure
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, Cai Qian <qcai@redhat.com>
In-Reply-To: <20080118090205.GA24337@elte.hu>
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu>
	 <4790145C.9060102@ct.jp.nec.com>  <20080118090205.GA24337@elte.hu>
Content-Type: text/plain
Organization: IBM
Date: Fri, 18 Jan 2008 14:59:13 +0530
Message-Id: <1200648553.4498.9.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-18 at 10:02 +0100, Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
> > kdump needs ELF_CORE_COPY_REGS in crash_save_cpu(). This lack of the 
> > macro causes the following BUG.
> > 
> > SysRq : Trigger a crashdump
> > ------------[ cut here ]------------
> > kernel BUG at include/linux/elfcore.h:105!
> > invalid opcode: 0000 [1] PREEMPT SMP
> 
> thanks, applied.
> 
> > +/*
> > + * regs is struct pt_regs, pr_reg is elf_gregset_t (which is
> > + * now struct_user_regs, they are different)
> > + */
> > +
> > +#define ELF_CORE_COPY_REGS(pr_reg, regs) do {		\
> 
> this macro got removed by the regset patches. Roland, any ideas?
> 
> 	Ingo
Hi Ingo/Hiroshi Shimamoto,

There also has been a huge update on ltp-kdump test suite. You can find
the same @ http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/kdump/,

--Subrata
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

