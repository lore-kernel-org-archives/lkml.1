Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab0CMOIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 09:08:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:42776 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab0CMOIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 09:08:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JUsBNwoXHijMfcegp8jARamcE5waF4qsiI6Plwsj0dyfh9sZU9+q4IKHNrkOf0TgCi
         cxjmUrpbzX9ZmHcpQSKMi24w7gw88g8qBTMt4hP4qaTGe5f4eruMA4364m57T1y3hUXp
         0iK2xzqgpa5UMOKNouG0OIR1A2e+K01FQtJ/s=
Date: Sat, 13 Mar 2010 17:08:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,perf: Unmask LVTPC only if we have APIC supported
Message-ID: <20100313140819.GC18623@lenovo>
References: <20100313081116.GA5179@lenovo> <20100313122432.GA10810@elte.hu> <20100313123256.GC5179@lenovo> <20100313124036.GA17769@elte.hu> <20100313134256.GB18623@lenovo> <20100313135022.GA4267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313135022.GA4267@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 02:50:22PM +0100, Ingo Molnar wrote:
[ ... ]
> > > 
> > > apic_write() is really just equivalent to a spin_lock() on UP without 
> > > UP_IOAPIC set - it should do nothing. So if it does something and fails the 
> > > build, then that should be fixed - not the P4 PMU code.
> > > 
> > > 	Ingo
> > > 
> > 
> > Looking at code a bit and config deps I think the former proposal with
> > #ifdef is minimal (in amount of changes) and sufficient. perf_event.c
> > uses #ifdef CONFIG_X86_LOCAL_APIC for the very same reason.
> > 
> > The former issue with config dependencies is that we may need to compile 
> > perf_event.c without CONFIG_LOCAL_APIC support at all (and this is a case 
> > for which you've posted the config). CONFIG_LOCAL_APIC deps on X86_UP_APIC, 
> > the config has no X86_UP_APIC support and as result -- no CONFIG_LOCAL_APIC 
> > and no apic.o compiled.
> > 
> > So, as expected, no apic_write/read and friends there. We may introduce 
> > apic_write/read weak(s) but this would only mess the code more and would 
> > smell unpleasant I think :) .
> > 
> > All-in-once: unresolved external symbol here, which could be fixed either by 
> > introducing dummy symbol, or conditional compilation. I think the second is 
> > preferred if the issue is just one line code.
> > 
> > Or you mean something different and I took a wrong mind-path?
> 
> Well it's not just one line of code as (like you mentioned) perf_event.c is 
> affected as well.
> 
> Introducing a dummy (NOP) placeholder method is what we are doing in all the 
> other cases (such as spin_lock()), we dont pollute the kernel with #ifdefs.
> 
> 	Ingo
> 

ok, understood what you mean. will back with patch.

	-- Cyrill
