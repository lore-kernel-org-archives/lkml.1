Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab0BETrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 14:47:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:34784 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755780Ab0BETrb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:47:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,415,1262592000"; 
   d="scan'208";a="490036877"
From: "Lu, Hongjiu" <hongjiu.lu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lachner, Peter" <peter.lachner@intel.com>
Date: Fri, 5 Feb 2010 11:47:25 -0800
Subject: RE: [patch] x86: ptrace and core-dump extensions for xstate
Thread-Topic: [patch] x86: ptrace and core-dump extensions for xstate
Thread-Index: Acql6Gik3I/wm2uATS+KdYOSQ9CNJgAs3s8A
Message-ID: <8EA2C2C4116BF44AB370468FBF85A7770123B84115@orsmsx504.amr.corp.intel.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	 <20100203230817.E6529AA@magilla.sf.frob.com>
	 <1265315329.2768.167.camel@sbs-t61.sc.intel.com>
	 <20100204205543.E1D11E7@magilla.sf.frob.com>
 <1265321114.2768.256.camel@sbs-t61.sc.intel.com> <4B6B47A1.3050606@zytor.com>
In-Reply-To: <4B6B47A1.3050606@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On 02/04/2010 02:05 PM, Suresh Siddha wrote:
> >
> > So in the example you provided before:
> >
> >         struct iovec iov = { mybuffer, mylength };
> >         ret = ptrace(PTRACE_GETREGSET, NT_X86_XSTATE, &iov);
> >
> > You wanted to propose common data format (iov) for all of the NT_* ?
> >
> 
> How about encoding the regset number into the command, e.g.
> ptrace(PTRACE_GETREGS(NT_X86_XSTATE), length, buffer)
> 
> ... where we have ...
> 
> #define PTRACE_GETREGS(r) (((r) << 16) | PTRACE_GETREGS_CMD)
> 
> ... or something like that?
> 

I like this idea.

BTW, it should be

ptrace(PTRACE_GETREGS(NT_X86_XSTATE), pid, length, buffer)


H.J.
