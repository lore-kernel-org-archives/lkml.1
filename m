Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZDEDtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZDEDtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 23:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbZDEDte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 23:49:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59732 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZDEDtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 23:49:33 -0400
Message-ID: <49D82A52.8050808@redhat.com>
Date: Sat, 04 Apr 2009 23:49:38 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [BUG][-tip] kprobes on module functions hits kernel BUG in 	text_poke
    on x86-32
References: <49D76FFF.6020202@redhat.com> <20090404154230.GB2451@Krystal> <49D7A6DF.8080804@redhat.com> <49D7AF26.5030808@redhat.com> <49D82987.5090003@redhat.com>
In-Reply-To: <49D82987.5090003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Hmm, ok. AFAICS, fixmap is only for lowmem, and pkmap is only for highmem.

Oops, I mean kmap...


> So, I think we have some options;
> 
> A) Separate text_poke into __text_poke and __text_poke_highmem. And
>   use pkmap_atomic in __text_poke_highmem. This way doesn't require
>   any additional change except adding KM_TEXT_POKE0/1 in km_type.
> 
> B) Add set_fixmap_page and use it in text_poke. This will require
>   changes in paravirt_ops and pgtable.c. We need to ensure there is
>   no side effects.
> 
> C) Change pkmap_atomic_prot to map lowmem only if the page's pgprot
>   is different from user specified pgprot. And use it instead of
>   fixmap. This also requires KM_TEXT_POKE0/1, however we can
>   remove FIX_TEXT_POKE0/1.

same, s/pkmap/kmap/g


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

