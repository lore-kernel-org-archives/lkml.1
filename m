Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbZDWWXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbZDWWXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758486AbZDWWXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:23:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40555 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZDWWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:23:10 -0400
Subject: Re: [PATCH -tip 3/6 V4.1] x86: instruction decorder API
From: Jim Keniston <jkenisto@us.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <49F0A570.8000908@redhat.com>
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>
	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com>
	 <1239058135.5212.43.camel@localhost.localdomain>
	 <49DA8857.8030607@zytor.com>  <49E7BFDC.8040305@redhat.com>
	 <1239926776.5883.17.camel@dyn9047018094.beaverton.ibm.com>
	 <49E7C87E.8000202@zytor.com>  <49EE6235.20706@redhat.com>
	 <1240447635.3713.21.camel@dyn9047018094.beaverton.ibm.com>
	 <49F0A570.8000908@redhat.com>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 15:22:32 -0700
Message-Id: <1240525367.3461.10.camel@dyn9047018094.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-23 at 13:29 -0400, Masami Hiramatsu wrote:
...
> 
> Hmm, maybe, parser can handle "(extra_info)" as a solid keyword.
> so let's define actual format.
> 
> <opcode maps>
> Table: table-name
> Referrer: escamed-name
> opcode: mnemonic|Grp [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
> opcode: ESC # escaped-name
> 
> <group maps>
> reg: mnemonic ...

For some instruction groups -- e.g., Groups 12, 13, 14 -- the
instruction prefix (66, f2, f3) and the reg field both affect the
instruction type.  And for some x87 instructions, the value of the modrm
byte's rm field also affects the instruction type.  (For others, rm just
selects among the st(0)..st(7) registers, as one might expect.)

Of course, that's all about floating-point instructions, which are of
more interest to uprobes than kprobes. 

Jim

