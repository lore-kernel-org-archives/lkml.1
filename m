Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab0BOSUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 13:20:52 -0500
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44737 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab0BOSUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 13:20:51 -0500
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Feb 2010 13:20:50 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sCGS5Z8/We5YVvIQPsRwtYQjbJMZ/4gYWsmXvcVRsLhZTBexBpi/El/u3r4bnViRyw
         PB+tYgL8cO++I117YWXr3EFfvOF6kdwSlBrfUHMptgR2iKe0hkQ+acL77QKPObuGy+H0
         cQpf/k1sOSmeTettuaEFmV4RcT63T+UXm11BM=
Date: Mon, 15 Feb 2010 21:13:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, aris@redhat.com,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/4] nmi_watchdog: use a boolean config flag for
	compiling
Message-ID: <20100215181301.GB5119@lenovo>
References: <1266013161-31197-1-git-send-email-dzickus@redhat.com> <20100214165941.GA26329@elte.hu> <20100215175106.GM3062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215175106.GM3062@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 12:51:06PM -0500, Don Zickus wrote:
> On Sun, Feb 14, 2010 at 05:59:41PM +0100, Ingo Molnar wrote:
> > 
> > i'm still getting build failures:
> > 
> > arch/x86/built-in.o: In function `arch_trigger_all_cpu_backtrace':
> > (.text+0x151f5): undefined reference to `apic'
> > 
> > config attached.
> 
> Hmm, I can't get the config to match up properly when I run 'make
> oldconfig', even though I am using the HEAD of perf/nmi.  I took the
> defaults anyway and used 'ARCH=i386 make all' but couldn't reproduce your
> build failure.
> 
> Looking through the code, is there ever case where 'apic' is undefined?
> The arch_trigger_all_cpu_backtrace should match identically to the old nmi
> code, so I am stuck on how to fix this.
> 
> Thoughts?
> 

It looks familiar to one problem with HW breakpoints "Kconfig select"
issue Frederic fixed once not that long ago, if I recall correctly.

So due to select we choose to compile hw_nmi.c, but CONFIG_LOCAL_APIC
(or APIC on UP) is turned off. So apic.c is not compiled. And at stage
of linking we get unresolved symbol.

I don't remember the details how Frederic fixed HW breakpoints "select"
issue, CC'ed :) But you may google to find it out.

> Cheers,
> Don
> 

n.b.: i remember about p4 pmu, still out of time :(

	-- Cyrill
