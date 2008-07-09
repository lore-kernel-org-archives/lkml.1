Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYGITFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYGITFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYGITFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:05:43 -0400
Received: from gw.goop.org ([64.81.55.164]:60086 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYGITFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:05:43 -0400
Message-ID: <48750BF6.4020209@goop.org>
Date: Wed, 09 Jul 2008 12:05:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874FCA7.3010507@sgi.com>
In-Reply-To: <4874FCA7.3010507@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> I did compartmentalize the changes so they were in separate patches,
> and in particular, by separating the changes to the include files, I
> was able to zero in on some problems much easier.
>
> But I have no objections to leaving the cpu_pda ops in place and then,
> as you're suggesting, extract and modify the fields as appropriate.
>
> Another approach would be to leave the changes from XXX_pda() to
> x86_percpu_XXX in place, and do the patches with simply changing
> pda.VAR to VAR .)
>   

Yes, but that's still two patches where one would do.  If I'm going to 
go through the effort of reconciling your percpu patches with my code, 
I'd like to be able to remove some #ifdef CONFIG_X86_64s in the process.

> In any case I would like to get this version working first, before
> attempting that rewrite, as that won't change the generated code.
>   

Well, as far as I can tell the real meat of the series is in 1-3 and the 
rest is fluff.  If just applying 1-3 works, then everything else should too.

> Btw, while I've got your attention... ;-), there's some code in
> arch/x86/xen/smp.c:xen_smp_prepare_boot_cpu() that should be looked
> at closer for zero-based per_cpu__gdt_page:
>
> 	make_lowmem_page_readwrite(&per_cpu__gdt_page);
>
> (I wasn't sure how to deal with this but I suspect the __percpu_offset[]
> or __per_cpu_load should be added to it.)

Already fixed in the mass of patches I posted yesterday.  I turned it 
into &per_cpu_var(gdt_page)).

    J
