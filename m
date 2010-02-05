Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0BEVQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:16:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab0BEVQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:16:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lu, Hongjiu" <hongjiu.lu@intel.com>,
       "Lachner, Peter" <peter.lachner@intel.com>
Subject: Re: [patch] x86: ptrace and core-dump extensions for xstate
In-Reply-To: H. Peter Anvin's message of  Thursday, 4 February 2010 14:18:09 -0800 <4B6B47A1.3050606@zytor.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	<20100203230817.E6529AA@magilla.sf.frob.com>
	<1265315329.2768.167.camel@sbs-t61.sc.intel.com>
	<20100204205543.E1D11E7@magilla.sf.frob.com>
	<1265321114.2768.256.camel@sbs-t61.sc.intel.com>
	<4B6B47A1.3050606@zytor.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20100205211515.9805FE7@magilla.sf.frob.com>
Date: Fri,  5 Feb 2010 13:15:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> #define PTRACE_GETREGS(r) (((r) << 16) | PTRACE_GETREGS_CMD)
> 
> ... or something like that?

(You can't use that exact name, it's taken.)  IMHO this is some spurious
obfuscation that is not warranted by saving the two get_user calls in the
kernel.  (OTOH, my suggestion requires a whole extra 5 lines of code or so
in compat_sys_ptrace because the indirection in the ABI is sensitive to
userland word size.)  But I don't feel strongly about the particulars of
the ptrace API addition, just that it be generic to cover any regset and
not be prone to implicit buffer-size miscommunications.  I'll leave it to
whatever Oleg wants to implement.


Thanks,
Roland
