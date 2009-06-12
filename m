Return-Path: <linux-kernel-owner+w=401wt.eu-S934437AbZFLWxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437AbZFLWxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZFLWxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:53:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZFLWxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:53:43 -0400
Message-ID: <4A32DBD1.30309@zytor.com>
Date: Fri, 12 Jun 2009 15:50:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>
Subject: Re: [RESEND][ PATCH -tip -v9 1/7] x86: instruction decoder API
References: <20090612224447.17311.72404.stgit@localhost.localdomain> <20090612224455.17311.19421.stgit@localhost.localdomain>
In-Reply-To: <20090612224455.17311.19421.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Add x86 instruction decoder to arch-specific libraries. This decoder
> can decode x86 instructions used in kernel into prefix, opcode, modrm,
> sib, displacement and immediates. This can also show the length of
> instructions.
> 
> This version introduces instruction attributes for decoding instructions.
> The instruction attribute tables are generated from the opcode map file
> (x86-opcode-map.txt) by the generator script(gen-insn-attr-x86.awk).
> 
> Currently, the opcode maps are based on opcode maps in Intel(R) 64 and
> IA-32 Architectures Software Developers Manual Vol.2: Appendix.A,
> and consist of below two types of opcode tables.
> 
> 1-byte/2-bytes/3-bytes opcodes, which has 256 elements, are
> written as below;
> 
>  Table: table-name
>  Referrer: escaped-name
>  opcode: mnemonic|GrpXXX [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
>   (or)
>  opcode: escape # escaped-name
>  EndTable
> 
> Group opcodes, which has 8 elements, are written as below;
> 
>  GrpTable: GrpXXX
>  reg:  mnemonic [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
>  EndTable
> 
> These opcode maps do NOT include most of SSE and FP opcodes, because
> those opcodes are not used in the kernel.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
> ---
> 

The decoder looks good by now.

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
