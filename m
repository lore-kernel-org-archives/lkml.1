Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbZDWR3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbZDWR3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZDWR30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:29:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39623 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZDWR3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:29:25 -0400
Message-ID: <49F0A570.8000908@redhat.com>
Date: Thu, 23 Apr 2009 13:29:20 -0400
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
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com>	 <1239058135.5212.43.camel@localhost.localdomain>	 <49DA8857.8030607@zytor.com>  <49E7BFDC.8040305@redhat.com>	 <1239926776.5883.17.camel@dyn9047018094.beaverton.ibm.com>	 <49E7C87E.8000202@zytor.com>  <49EE6235.20706@redhat.com> <1240447635.3713.21.camel@dyn9047018094.beaverton.ibm.com>
In-Reply-To: <1240447635.3713.21.camel@dyn9047018094.beaverton.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Keniston wrote:
> On Tue, 2009-04-21 at 20:17 -0400, Masami Hiramatsu wrote:
> ...
>> Hi Peter and Jim,
>>
>> Now what I'm doing is making opcode tables like this.
>>
>> Table: 1-byte opcode
>> Alias: none
>> 00: ADD Eb,Gb
>> 01: ADD Ev,Gv
>> 02: ADD Gb,Eb
>> 03: ADD Gv,Ev
>> 04: ADD AL,Ib
>> 05: ADD rAX,Iz
>> 06: PUSH ES (i64)
>> 07: POP ES (i64)
>> 08: OR Eb,Gb
>> 09: OR Ev,Gv
>> 0a: OR Gb,Eb
>> 0b: OR Gv,Ev
>> 0c: OR AL,Ib
>> 0d: OR rAX,Iz
>> 0e: PUSH CS
>> 0f: 2-byte escape
>> ...
> 
> We want to keep this info easy to parse. (Who knows how it might be
> used, and by whom?)  Your format seems to be
> 	opcode: mnemonic [comma,separated,operands] [(extra_info)]
> which is fine if you stick to it... but your entry for 0f doesn't match
> that.

Sure, it was just based on the original opcode map.
Maybe, we can have something special expressions for that.
e.g.
0f: ESC # 2-byte escape

> Also, something like
> 	+ extra_info
> would be easier to parse (using, say, awk) than
> 	(extra_info)

Hmm, maybe, parser can handle "(extra_info)" as a solid keyword.
so let's define actual format.

<opcode maps>
Table: table-name
Referrer: escamed-name
opcode: mnemonic|Grp [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
opcode: ESC # escaped-name

<group maps>
reg: mnemonic ...


Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


