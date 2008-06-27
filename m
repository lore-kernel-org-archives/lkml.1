Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYF0InT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYF0InT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYF0InJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:43:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:48946 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbYF0InH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=o50yU7+6MOcEwRM/UEAyNLkMXMXPgPLtp4Udis55kPi91Gh06tGqq9BK7mlKjexDCy
         t2x3yxdvb8zZfV2AvNbBT7O2pDZJWH1+wC5baZYIcCU+NmTrG3x4mlfknOssIg4L6PU8
         L23ZJTQlo2I6XPeIRwdiIcG1d2gdsCqZv64EI=
Message-ID: <7c86c4470806270143u42321a93g708d839166de5a1c@mail.gmail.com>
Date: Fri, 27 Jun 2008 10:43:06 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [patch 05/19] perfmon2 minimal v2: X86 generic code
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080624021120.2bcca593.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4858346e.0c58560a.394e.3498@mx.google.com>
	 <20080624021120.2bcca593.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

Ok, so I cloned your linux-next tree and ported by perfmon2 minimal patch
series to it. As you said, there was a handful of files which caused problems,
mostly because of x86 merge. But the net effect is that the series is now a bit
smaller. I tried some simple perfmon tests and they worked fine. I did not go
all the way to the patch which needed IPI (i.e. system-wide support).

However I had problems with this tree and my Broadcom BMC5754 network
card. It was not recognized by the tg3 driver so hard to use this kernel.


On Mon, Jun 23, 2008 at 6:11 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Stephane,
>
> On Tue, 17 Jun 2008 15:02:22 -0700 (PDT) eranian@googlemail.com wrote:
>>
>> This patch adds the X86 generic perfmon2 code. It is in charge of
>> implementing certain key functionalities required by the generic
>> code such as read/write of the PMU registers, low-level interrupt
>> handling.
>
> After applying patches 1-5, building an x86_64 allmodconfig produces
> these errors:
>
> In file included from include/linux/perfmon_kern.h:167,
>                 from arch/x86/perfmon/perfmon.c:25:
> include/linux/perfmon_pmu.h:92: warning: 'struct pfarg_pmc' declared inside parameter list
> include/linux/perfmon_pmu.h:92: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/perfmon_pmu.h:96: warning: 'struct pfarg_pmd' declared inside parameter list
>
> Those structures aren't defined until patch 11.
>
> In file included from arch/x86/perfmon/perfmon.c:25:
> include/linux/perfmon_kern.h: In function 'pfm_copy_thread':
> include/linux/perfmon_kern.h:199: error: 'TIF_PERFMON_CTXSW' undeclared (first use in this function)
> arch/x86/perfmon/perfmon.c: In function 'smp_pmu_interrupt':
> arch/x86/perfmon/perfmon.c:338: error: 'LOCAL_PERFMON_VECTOR' undeclared (first use in this function)
> arch/x86/perfmon/perfmon.c: In function 'pfm_arch_resend_irq':
> arch/x86/perfmon/perfmon.c:451: error: 'LOCAL_PERFMON_VECTOR' undeclared (first use in this function)
> arch/x86/perfmon/perfmon.c: In function 'pfm_arch_pmu_acquire_percpu':
> arch/x86/perfmon/perfmon.c:475: error: 'LOCAL_PERFMON_VECTOR' undeclared (first use in this function)
>
> These are not defined until patch 7.
>
> So I think some rearrangement is still required.
>
> Also, some of the x86 files that you are modifying have had their 32 and
> 64 bit versions combined in linux-next (which is the stuff of the next
> merge window) so just a heads up that there will be more merge work then.
> Lastly, some of this will clash with the generic IPIs work.
>
> I don't want to put you off, you have done great work here, thanks.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
