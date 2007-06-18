Return-Path: <linux-kernel-owner+w=401wt.eu-S1764687AbXFRTdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764687AbXFRTdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761528AbXFRTdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:33:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:40509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761126AbXFRTdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:33:10 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 4/8] Immediate Value - i386 Optimization; kprobes
Date: Mon, 18 Jun 2007 21:32:56 +0200
User-Agent: KMail/1.9.6
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, prasanna@in.ibm.com, ananth@in.ibm.com
References: <20070615202310.178466032@polymtl.ca> <4676D2A9.6090403@redhat.com> <20070618115632.7aca8c0f.akpm@linux-foundation.org>
In-Reply-To: <20070618115632.7aca8c0f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706182132.56559.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007 20:56:32 Andrew Morton wrote:
> On Mon, 18 Jun 2007 14:44:57 -0400
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > > I fancy it's done by the kprobe_page_fault handler, but I do not see
> > > clearly how writing the breakpoint from arch_arm_kprobe() in
> > > non-writeable memory is done.
> > 
> > Looks like it's not merged yet:
> > 
> > http://lkml.org/lkml/2007/6/7/2
> > 
> > This needs to go in before 2.6.22-final
> 
> Andi, I'll include the below two patches in the next batch, OK?

It won't work reliably unless some of the c_p_a() fixes get in first.

> 
> 
> 
> +extern int kernel_text_is_ro;

No externs in .c files


I also don't like kernel_text_is_read_only() much, it would
be better to just lookup_address() it and check the write flag.

But for 2.6.22 as a quick fix it might be better to just
make KPROBES dependent on !DEBUG_RODATA. That would be a one liner.

-Andi
