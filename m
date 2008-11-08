Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYKHCe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYKHCe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 21:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYKHCeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 21:34:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYKHCeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 21:34:46 -0500
Message-ID: <4914FA8D.4000607@redhat.com>
Date: Fri, 07 Nov 2008 21:33:49 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, maneesh@in.ibm.com,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Srinivasa Ds <srinivasa@in.ibm.com>
Subject: Re: [PATCH] kprobe: increase kprobe_hash_table size
References: <4914D2DE.9030603@redhat.com>	<20081107155646.b375413e.akpm@linux-foundation.org>	<4914DAEE.2050301@redhat.com> <20081107170307.1a4f815e.akpm@linux-foundation.org>
In-Reply-To: <20081107170307.1a4f815e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> I agree that there may be many opinions about what is the best suited size.
>> Why I chose 512 was that I thought the table (byte) size was less than or
>> equal 4096 even on 64-bit arch.
> 
> Well...
> 
>    text    data     bss     dec     hex filename
>    7036     744    9380   17160    4308 kernel/kprobes.o
>    7048     744   73892   81684   13f14 kernel/kprobes.o
> 
> That's 64 kbytes more memory.  It will be kretprobe_table_locks[] which
> is hurting here, due to the ____cacheline_aligned.

Oops! It's really bad.


> I expected CONFIG_X86_VSMP=y to make this far worse, but fortunately
> that only affects ____cacheline_internodealigned_in_smp.
> 
> btw, that array wastes a ton of memory on uniprocessor builds.  Using
> ____cacheline_aligned_in_smp should fix that.
> 
> Please always check these thigns with /usr/bin/size.

I see. I'll check that and try to find the best way...

> btw2, could/should kprobe_table[] and kretprobe_inst_table[] be
> aggregated into kretprobe_table_locks[]?  That would save some memory
> and might save some cache misses as well?

Indeed, thank you for good idea.

> Anyway, enough pos-facto code review.  Is this change which you're
> proposing worth increasing kernel memory usage by 64k?

Not really. Hmm, I have to investigate more on this problem.

Thanks a lot.

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

