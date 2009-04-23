Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbZDWAr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbZDWAr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZDWArU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:47:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47056 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZDWArT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:47:19 -0400
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
In-Reply-To: <49EE6235.20706@redhat.com>
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>
	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com>
	 <1239058135.5212.43.camel@localhost.localdomain>
	 <49DA8857.8030607@zytor.com>  <49E7BFDC.8040305@redhat.com>
	 <1239926776.5883.17.camel@dyn9047018094.beaverton.ibm.com>
	 <49E7C87E.8000202@zytor.com>  <49EE6235.20706@redhat.com>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 17:47:00 -0700
Message-Id: <1240447635.3713.21.camel@dyn9047018094.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 20:17 -0400, Masami Hiramatsu wrote:
...
> Hi Peter and Jim,
> 
> Now what I'm doing is making opcode tables like this.
> 
> Table: 1-byte opcode
> Alias: none
> 00: ADD Eb,Gb
> 01: ADD Ev,Gv
> 02: ADD Gb,Eb
> 03: ADD Gv,Ev
> 04: ADD AL,Ib
> 05: ADD rAX,Iz
> 06: PUSH ES (i64)
> 07: POP ES (i64)
> 08: OR Eb,Gb
> 09: OR Ev,Gv
> 0a: OR Gb,Eb
> 0b: OR Gv,Ev
> 0c: OR AL,Ib
> 0d: OR rAX,Iz
> 0e: PUSH CS
> 0f: 2-byte escape
> ...

We want to keep this info easy to parse. (Who knows how it might be
used, and by whom?)  Your format seems to be
	opcode: mnemonic [comma,separated,operands] [(extra_info)]
which is fine if you stick to it... but your entry for 0f doesn't match
that.

Also, something like
	+ extra_info
would be easier to parse (using, say, awk) than
	(extra_info)

> 
> and a parser script which parses them into,
> 
> const insn_attr_t primary_table[INAT_TABLE_SIZE] = {
> 	[0x04] = INAT_IMM(IMM_SIZE_BYTE)
> 	[0x05] = INAT_IMM(IMM_SIZE_VWORD32)
> 	[0x0c] = INAT_IMM(IMM_SIZE_BYTE)
> 	[0x0d] = INAT_IMM(IMM_SIZE_VWORD32)
> 	[0x0f] = INAT_ESC(IMM_ESC_2BYTE)
> ...
> 
> (note, instructions which has no attributes for decoder, are just ignored)
> 
> 
> By the way, I'm worried about legal things of Intel's instruction
> encoding expressions. Would you think there is any problem if we
> have those tables in the kernel tree?

Good question.  Sorry, I'm not a lawyer.  Intel and AMD and sandpile.org
all seem to be using the same notation, so the notation's inventor must
not be feeling too proprietary.  Interestingly, sandpile.org asserts a
copyright.

> 
> Thanks,
> 

Jim

