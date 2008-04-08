Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYDHThA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYDHThA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYDHTgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:36:53 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:52358 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYDHTgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kpt2eeBhJURhRimWFKDJAFSDMhKtoBNj2MicwU4Do0+GtIHRV1dNG4VpODdXaPdA0bIhU/Dkh9GPNQ2yAcbXGyzLR4W4Ekg1cryKx4a57ggvTgYyIcPhBaGJ5ZsT2wdXVxzUkCInLVKtOuH8a+0I2rL7z3do0jiznPaoHfi+Mls=
Message-ID: <36ca99e90804081236ifa3eecfue3dd211f9cdcb32a@mail.gmail.com>
Date: Tue, 8 Apr 2008 21:36:49 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/3] x86: modify show_shared_cpu_map in intel_cacheinfo v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080408184301.842103000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	 <20080408184301.842103000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>  --- linux-2.6.x86.sched.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
>  +++ linux-2.6.x86.sched/arch/x86/kernel/cpu/intel_cacheinfo.c
>  @@ -591,20 +591,34 @@ static ssize_t show_size(struct _cpuid4_
>         return sprintf (buf, "%luK\n", this_leaf->size / 1024);
>   }
>
>  -static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
>  +static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
>  +                                       int type, char *buf)
I don't know if this is more efficient or better or cleaner, but how
about to pass the function pointer (ie. cpulist_scnprintf or
cpumap_scnprintf)? You safe at least one condition.

>  +               n = type?
>  +                       cpulist_scnprintf(buf, len-2, *mask):
>  +                       cpumask_scnprintf(buf, len-2, *mask);

Thanks.
Bert
