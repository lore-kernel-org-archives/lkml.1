Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZHTAVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZHTAVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 20:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZHTAVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 20:21:20 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:55704 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZHTAVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 20:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=NNO7chfZuqzQakcAJjh16q06ljJati9ngXb+ejXKY7LHWbGLjn9Lyz44UJu74s89u+
         tW2PpNkR3WjDPItbCVEUqRFR783kyGonw8nCDLVX7HPLaA3GW/pqEieUzo6kCEbWE1Zc
         Pt7no62yJtBrmRwx3+EpF6q/jfWa2SSQeBuJc=
Date: Thu, 20 Aug 2009 02:21:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
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
       =?utf-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip v14 01/12] x86: instruction decoder API
Message-ID: <20090820002113.GK4972@nowhere>
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <20090813203413.31965.49709.stgit@localhost.localdomain> <20090819234227.GJ4972@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090819234227.GJ4972@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 01:42:31AM +0200, Frederic Weisbecker wrote:
> On Thu, Aug 13, 2009 at 04:34:13PM -0400, Masami Hiramatsu wrote:
> > Add x86 instruction decoder to arch-specific libraries. This decoder
> > can decode x86 instructions used in kernel into prefix, opcode, modrm,
> > sib, displacement and immediates. This can also show the length of
> > instructions.
> > 
> > This version introduces instruction attributes for decoding instructions.
> > The instruction attribute tables are generated from the opcode map file
> > (x86-opcode-map.txt) by the generator script(gen-insn-attr-x86.awk).
> > 
> > Currently, the opcode maps are based on opcode maps in Intel(R) 64 and
> > IA-32 Architectures Software Developers Manual Vol.2: Appendix.A,
> > and consist of below two types of opcode tables.
> > 
> > 1-byte/2-bytes/3-bytes opcodes, which has 256 elements, are
> > written as below;
> > 
> >  Table: table-name
> >  Referrer: escaped-name
> >  opcode: mnemonic|GrpXXX [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
> >   (or)
> >  opcode: escape # escaped-name
> >  EndTable
> > 
> > Group opcodes, which has 8 elements, are written as below;
> > 
> >  GrpTable: GrpXXX
> >  reg:  mnemonic [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
> >  EndTable
> > 
> > These opcode maps include a few SSE and FP opcodes (for setup), because
> > those opcodes are used in the kernel.
> > 
> 
> 
> I'm getting the following build error on an old K7 box:
> 
> arch/x86/lib/inat.c: In function ‘inat_get_opcode_attribute’:
> arch/x86/lib/inat.c:29: erreur: ‘inat_primary_table’ undeclared (first use in this function)
> arch/x86/lib/inat.c:29: erreur: (Each undeclared identifier is reported only once
> arch/x86/lib/inat.c:29: erreur: for each function it appears in.)
> 
> 
> I've attached my config. I haven't such problem on a dual x86-64 box.


Actually I have the same problem in x86-64
The content of my arch/x86/lib/inat-tables.c:

/* x86 opcode map generated from x86-opcode-map.txt */
/* Do not change this code. */
/* Table: one byte opcode */
/* Escape opcode map array */
const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1][INAT_LPREFIX_MAX + 1] = {
};

/* Group opcode map array */
const insn_attr_t const *inat_group_tables[INAT_GRP_MAX + 1][INAT_LPREFIX_MAX + 1] = {
};


I guess there is a problem with the generation of this file.

