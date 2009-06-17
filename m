Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbZFQW0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbZFQW0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZFQW0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:26:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55403 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbZFQW0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:26:06 -0400
Message-ID: <4A396DD6.2050002@redhat.com>
Date: Wed, 17 Jun 2009 18:27:34 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [RFC][ PATCH -tip 0/6] kprobes: Kprobes jump optimization support
References: <20090612224925.17825.49637.stgit@localhost.localdomain> <alpine.DEB.1.10.0906131031570.29895@vinegar-pot.mit.edu> <4A381F8A.8020105@redhat.com>
In-Reply-To: <4A381F8A.8020105@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
>> (1) The compiler is allowed to do cross-function optimization within a 
>> compilation unit where code in one function jumps into the middle of 
>> another function.
> 
> Hmm, right. This is a real problem. I think I have 2 options for this
> issue. I counted the cross-function jumps on my kernel roughly, and
> I found there were about 856 jumps jump into 158 functions (it might be
> incorrect, I just used 'objdump -d', and it also disassembles data
> section...)

Hmm, almost all of these functions are jumped from .fixup section.
Obviously, these should be mentioned.

> - Making a blacklist of target functions or addresses which cross-function
>   jumps jump into. This will be done by disassembling kernel when starting up
>   kernel and loading modules.(or, at build-time)

If we can make this blacklist, it will include above .fixup section.

> 
> - Just disables cross-function optimization by adding --param
>   min-crossjump-insns=XXXX where XXXX is enough big number, when
>   CONFIG_OPTPROBES=y

BTW, I've tried to compile with min-crossjump-insns=32768. It actually
increased vmlinux size (about 1%),

   text    data     bss     dec     hex filename
5767574 2022487 1521264 9311325  8e145d vmlinux-crossjump
5809551 2022487 1521264 9353302  8eb856 vmlinux-noncrossjump

However, with crossjumps opt, it seems not to add any jumps which
jump into the middle of other functions...

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

