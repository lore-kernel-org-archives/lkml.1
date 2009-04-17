Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbZDQNcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbZDQNcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbZDQNcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:32:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51303 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395AbZDQNcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:32:07 -0400
Message-ID: <49E884C2.9030409@redhat.com>
Date: Fri, 17 Apr 2009 09:31:46 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com> <1239058135.5212.43.camel@localhost.localdomain> <49DA8857.8030607@zytor.com> <49E7BFDC.8040305@redhat.com> <49E7C1B3.1070000@zytor.com>
In-Reply-To: <49E7C1B3.1070000@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Masami Hiramatsu wrote:
>>
>> Hmm, I have an idea about instruction table. Usually, instruction tables
>> are encoded with code defined by each decoder/emulator. This method
>> will show their internal code directly, and is hard to maintain when
>> the opcode map is updated. Instead of that, I'd like to suggest using
>> the expressions in the opcode maps in a vender's genuine document (in
>> this case, Intel/AMD's manual) or www.sandpile.org for instruction
>> tables.
>>
> 
> Yes, we discussed this at the Collab Summit.  I think it's the only sane
> thing.
> 
>> e.g.
>>
>> const insn_attr_t onebyte_attr_table[ATTR_TABLE_SIZE] = {
>> /* 0x00-0x0f */
>> AT2(Eb,Gb), AT2(Ev,Gv),  AT2(Gb,Eb),  AT2(Gv,Ev),
>> AT2(AL,Ib), AT2(rAX,Iz), AT2(ES,i64), AT2(ES,i64),
>> AT2(Eb,Gb), AT2(Ev,Gv),  AT2(Gb,Eb),  AT2(Gv,Ev),
>> AT2(AL,Ib), AT2(rAX,Iz), AT2(CS,i64), AT(ESC),
>> ...
>>
>> Here, AT and AT2 macros are defined as follows:
>>
> 
> I would suggest using an actual parser, rather than relying on cpp for
> this.  The parser will be much more powerful, and will make it much
> easier to change data structure radically as we discussed.

Aah, I see. So we'd better make a parser which generates internal
data structure from genuine opcode map in compilation time.

And I changed my mind about internal data structure too.
In this version, I'll use a smallest bits which are needed
for the decoder.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

