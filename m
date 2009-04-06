Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbZDFW5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbZDFW5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZDFW5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:57:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZDFW5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:57:03 -0400
Message-ID: <49DA8857.8030607@zytor.com>
Date: Mon, 06 Apr 2009 15:55:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>
CC: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com> <1239058135.5212.43.camel@localhost.localdomain>
In-Reply-To: <1239058135.5212.43.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Keniston wrote:
> 
> For user-space probing, we've been concentrating on native-built
> executables.  Am I correct in thinking that we'll see 16-bit or V86 mode
> only on legacy apps built elsewhere?  In any case, it only makes sense
> to build on the kvm folks' work in this regard.
> 

That's a fair assumption; you will of course need to test it and take
appropriate action if it doesn't pan out.

> 
> As noted, the INAT tables follow the kvm model of one fat bitmap of
> attributes per opcode, rather than the kprobes/uprobes model of one or
> two 256-bit tables per attribute.  (This latter approach was due to the
> gradual accumulation of tables over the years.)
> 
> I like the bitmap-per-opcode approach because it's relatively easy to
> see in one place everything you're saying about a particular opcode.
> But with all the potential clients for this service, it's not clear that
> we'll get by with a single bitmap for every opcode.  (x86 kvm uses 32
> bits per opcode, I think, and the INAT tables use 10.  Seems like we
> could overrun 64 bits pretty quickly.)  So I guess that means we'll have
> to get a little creative as to how we expose these attribute sets to the
> client.
> 

This is another very good reason to use an instruction table which is
preprocessed into a usable format: it means that if the internal data
structures change -- and they almost certainly will have to at some
point -- the raw data isn't lost.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

