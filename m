Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZDXDy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZDXDy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 23:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZDXDyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 23:54:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54954 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbZDXDyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 23:54:16 -0400
Message-ID: <49F137B8.9020707@redhat.com>
Date: Thu, 23 Apr 2009 23:53:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH -tip 3/6 V4.1] x86: instruction decorder API
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com>	 <1239058135.5212.43.camel@localhost.localdomain>	 <49DA8857.8030607@zytor.com>  <49E7BFDC.8040305@redhat.com>	 <1239926776.5883.17.camel@dyn9047018094.beaverton.ibm.com>	 <49E7C87E.8000202@zytor.com>  <49EE6235.20706@redhat.com>	 <1240447635.3713.21.camel@dyn9047018094.beaverton.ibm.com>	 <49F0A570.8000908@redhat.com> <1240525367.3461.10.camel@dyn9047018094.beaverton.ibm.com>
In-Reply-To: <1240525367.3461.10.camel@dyn9047018094.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Keniston wrote:
> On Thu, 2009-04-23 at 13:29 -0400, Masami Hiramatsu wrote:
> ...
>> Hmm, maybe, parser can handle "(extra_info)" as a solid keyword.
>> so let's define actual format.
>>
>> <opcode maps>
>> Table: table-name
>> Referrer: escamed-name
>> opcode: mnemonic|Grp [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]

This should be:
opcode: mnemonic|GrpXXX ...

>> opcode: ESC # escaped-name

This should be
opcode: escape # escaped-name
because distinguishing from x87 ESC ops.

>>
>> <group maps>
>> reg: mnemonic ...
> 
> For some instruction groups -- e.g., Groups 12, 13, 14 -- the
> instruction prefix (66, f2, f3) and the reg field both affect the
> instruction type.  And for some x87 instructions, the value of the modrm
> byte's rm field also affects the instruction type.  (For others, rm just
> selects among the st(0)..st(7) registers, as one might expect.)

Sure, I updated the format. There are some special cases,

(1) instructions which are switched by 64bit mode
40: INC eAX (i64) | REX (o64)

(2) instructions which are switched by the last prefix
13: movlps Mq,Vq | movlpd Mq,Vq (66)

(3) group instructions which are switched by modr/m
0: SGDT Ms | VMCALL (11B),(001) | VMLAUNCH (11B),(010) | VMRESUME (11B),(011) | VMXOFF (11B),(100)


> 
> Of course, that's all about floating-point instructions, which are of
> more interest to uprobes than kprobes. 

Hmm, x87 instructions may need to have some special format...

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

