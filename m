Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZHTOj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZHTOj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZHTOj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:39:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbZHTOj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:39:56 -0400
Message-ID: <4A8D60BD.8010100@redhat.com>
Date: Thu, 20 Aug 2009 10:42:05 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip v14 01/12] x86: instruction decoder API
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <20090813203413.31965.49709.stgit@localhost.localdomain> <20090819234227.GJ4972@nowhere>
In-Reply-To: <20090819234227.GJ4972@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Aug 13, 2009 at 04:34:13PM -0400, Masami Hiramatsu wrote:
>> Add x86 instruction decoder to arch-specific libraries. This decoder
>> can decode x86 instructions used in kernel into prefix, opcode, modrm,
>> sib, displacement and immediates. This can also show the length of
>> instructions.
>>
>> This version introduces instruction attributes for decoding instructions.
>> The instruction attribute tables are generated from the opcode map file
>> (x86-opcode-map.txt) by the generator script(gen-insn-attr-x86.awk).
>>
>> Currently, the opcode maps are based on opcode maps in Intel(R) 64 and
>> IA-32 Architectures Software Developers Manual Vol.2: Appendix.A,
>> and consist of below two types of opcode tables.
>>
>> 1-byte/2-bytes/3-bytes opcodes, which has 256 elements, are
>> written as below;
>>
>>   Table: table-name
>>   Referrer: escaped-name
>>   opcode: mnemonic|GrpXXX [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
>>    (or)
>>   opcode: escape # escaped-name
>>   EndTable
>>
>> Group opcodes, which has 8 elements, are written as below;
>>
>>   GrpTable: GrpXXX
>>   reg:  mnemonic [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
>>   EndTable
>>
>> These opcode maps include a few SSE and FP opcodes (for setup), because
>> those opcodes are used in the kernel.
>>
>
>
> I'm getting the following build error on an old K7 box:
>
> arch/x86/lib/inat.c: In function ‘inat_get_opcode_attribute’:
> arch/x86/lib/inat.c:29: erreur: ‘inat_primary_table’ undeclared (first use in this function)
> arch/x86/lib/inat.c:29: erreur: (Each undeclared identifier is reported only once
> arch/x86/lib/inat.c:29: erreur: for each function it appears in.)

Thanks for reporting!
Hmm, it seems that inat-tables.c is not correctly generated.
Could you tell me which awk you used and send the inat-tables.c?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

