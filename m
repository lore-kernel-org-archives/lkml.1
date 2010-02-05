Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab0BEVkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:40:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:29476 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933844Ab0BEVkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:40:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,415,1262592000"; 
   d="scan'208";a="241031724"
Subject: Re: [patch] x86: ptrace and core-dump extensions for xstate
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lu, Hongjiu" <hongjiu.lu@intel.com>,
       "Lachner, Peter" <peter.lachner@intel.com>
In-Reply-To: <20100205211515.9805FE7@magilla.sf.frob.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	 <20100203230817.E6529AA@magilla.sf.frob.com>
	 <1265315329.2768.167.camel@sbs-t61.sc.intel.com>
	 <20100204205543.E1D11E7@magilla.sf.frob.com>
	 <1265321114.2768.256.camel@sbs-t61.sc.intel.com>
	 <4B6B47A1.3050606@zytor.com>  <20100205211515.9805FE7@magilla.sf.frob.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 05 Feb 2010 13:39:14 -0800
Message-Id: <1265405954.2812.89.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 13:15 -0800, Roland McGrath wrote:
> > #define PTRACE_GETREGS(r) (((r) << 16) | PTRACE_GETREGS_CMD)
> > 
> > ... or something like that?
> 
> (You can't use that exact name, it's taken.)  IMHO this is some spurious
> obfuscation that is not warranted by saving the two get_user calls in the
> kernel.  

Also value of NT_PRXFPREG complicates things bit more

#define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */

In this context, we have to perhaps use bits 31 and 29 to represent this
generic ptrace interface and the corresponding GET/SET commands.

> (OTOH, my suggestion requires a whole extra 5 lines of code or so
> in compat_sys_ptrace because the indirection in the ABI is sensitive to
> userland word size.)  But I don't feel strongly about the particulars of
> the ptrace API addition, just that it be generic to cover any regset and
> not be prone to implicit buffer-size miscommunications.  I'll leave it to
> whatever Oleg wants to implement.

Ok. I will split the previous patch in to two patches and re-post it. I
can help Oleg with reviewing and testing the generic implementation
whenever it is ready.

thanks,
suresh

