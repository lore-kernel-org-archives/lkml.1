Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab0BDWVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 17:21:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41784 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831Ab0BDWVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 17:21:52 -0500
Message-ID: <4B6B47A1.3050606@zytor.com>
Date: Thu, 04 Feb 2010 14:18:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lu, Hongjiu" <hongjiu.lu@intel.com>,
       "Lachner, Peter" <peter.lachner@intel.com>
Subject: Re: [patch] x86: ptrace and core-dump extensions for xstate
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>	 <20100203230817.E6529AA@magilla.sf.frob.com>	 <1265315329.2768.167.camel@sbs-t61.sc.intel.com>	 <20100204205543.E1D11E7@magilla.sf.frob.com> <1265321114.2768.256.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1265321114.2768.256.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2010 02:05 PM, Suresh Siddha wrote:
> 
> So in the example you provided before:
> 
>         struct iovec iov = { mybuffer, mylength };
>         ret = ptrace(PTRACE_GETREGSET, NT_X86_XSTATE, &iov);
> 
> You wanted to propose common data format (iov) for all of the NT_* ?
> 

How about encoding the regset number into the command, e.g.
ptrace(PTRACE_GETREGS(NT_X86_XSTATE), length, buffer)

... where we have ...

#define PTRACE_GETREGS(r) (((r) << 16) | PTRACE_GETREGS_CMD)

... or something like that?

	-hpa

