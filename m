Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab0BDFde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 00:33:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:26324 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab0BDFdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 00:33:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,402,1262592000"; 
   d="scan'208";a="593026241"
From: "Lu, Hongjiu" <hongjiu.lu@intel.com>
To: Roland McGrath <roland@redhat.com>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lachner, Peter" <peter.lachner@intel.com>
Date: Wed, 3 Feb 2010 21:32:29 -0800
Subject: RE: [patch] x86: ptrace and core-dump extensions for xstate
Thread-Topic: [patch] x86: ptrace and core-dump extensions for xstate
Thread-Index: AcqlWXpOePDjigGhQOCRC3myg+xj9QAAE3lw
Message-ID: <8EA2C2C4116BF44AB370468FBF85A7770123AAB3C7@orsmsx504.amr.corp.intel.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	<20100203230817.E6529AA@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB0AE@orsmsx504.amr.corp.intel.com>
	<20100204020224.45379725@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB2E8@orsmsx504.amr.corp.intel.com>
	<20100204021659.AB348C880@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB303@orsmsx504.amr.corp.intel.com>
	<20100204045458.5AA2F7290@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB3A1@orsmsx504.amr.corp.intel.com>
 <20100204051816.E8F68815A@magilla.sf.frob.com>
In-Reply-To: <20100204051816.E8F68815A@magilla.sf.frob.com>
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
> > > Suresh's patch puts this value in the xsave block, in what Suresh calls
> > > "sw_usable_bytes".  See the asm/ptrace-abi.h comment in the patch you
> > > signed off on.
> > >
> > > How is that not sufficient?  If it is indeed not sufficient to usefully
> > > interpret the xsave block, then how could an xsave block in a core dump
> > > file ever possibly be examined if it might not have been generated on the
> > > same system and kernel where the debugger is doing the examination?  If
> > > the NT_X86_XSTATE note as implemented in Suresh's patch is indeed not
> > > entirely self-contained in this way, then NAK on that new note format.
> > >
> >
> > I use it when reading core dump, which doesn't involve a system call.
> > I can analyze it on a totally different machine.
> 
> You did not answer any of my questions.
> Perhaps Suresh can be more helpful in explaining the situation.
> 

When gdb reads a core section, it only processes up to the maximum
xsave size it supports and ignores the rest. It also reads the first 8
byte in sw_usable_bytes for xcr0. It only exams the xcr0 bits it supports.
With this info, gdb can exams xsave core dump up to the state it supports.

When it calls ptrace with XSTATE, it uses a buffer of the
size returned by cpuid. But it only reads up to the xsave size
it supports.

The difference here is the size of core dump is recorded in core
dump and I have to use cpuid returned size to make a ptrace call.

H.J.
