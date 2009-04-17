Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbZDQAGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbZDQAGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZDQAG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:06:26 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48318 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbZDQAGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:06:25 -0400
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
In-Reply-To: <49E7BFDC.8040305@redhat.com>
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>
	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com>
	 <1239058135.5212.43.camel@localhost.localdomain>
	 <49DA8857.8030607@zytor.com>  <49E7BFDC.8040305@redhat.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 17:06:01 -0700
Message-Id: <1239926776.5883.17.camel@dyn9047018094.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 19:31 -0400, Masami Hiramatsu wrote:
...
> 
> Hmm, I have an idea about instruction table. Usually, instruction tables
> are encoded with code defined by each decoder/emulator. This method
> will show their internal code directly, and is hard to maintain when
> the opcode map is updated. Instead of that, I'd like to suggest using
> the expressions in the opcode maps in a vender's genuine document (in
> this case, Intel/AMD's manual) or www.sandpile.org for instruction
> tables.
> 
> e.g.
> 
> const insn_attr_t onebyte_attr_table[ATTR_TABLE_SIZE] = {
> /* 0x00-0x0f */
> AT2(Eb,Gb), AT2(Ev,Gv),  AT2(Gb,Eb),  AT2(Gv,Ev),
> AT2(AL,Ib), AT2(rAX,Iz), AT2(ES,i64), AT2(ES,i64),
> AT2(Eb,Gb), AT2(Ev,Gv),  AT2(Gb,Eb),  AT2(Gv,Ev),
> AT2(AL,Ib), AT2(rAX,Iz), AT2(CS,i64), AT(ESC),
> ...
> 
> Here, AT and AT2 macros are defined as follows:
> 
> #define AT(a) (INAT_OMEXP_##a)
> #define AT2(a1, a2) (INAT_OMEXP_##a1 | INAT_OMEXP_##a2)
> 
...

It looks like AT2(Ev,Gv) would yield the same bits as AT2(Gv,Ev).  It'd
be nice not to lose the operand-order information.  And we'd have to
make clear whether which notation we're using -- src,dest as in the gnu
assembler, or dest,src as in the AMD (and Intel?) manuals.

Jim

