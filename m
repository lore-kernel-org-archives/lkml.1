Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYHRUhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYHRUhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYHRUh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:37:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:1816 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbYHRUh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:37:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,230,1217833200"; 
   d="scan'208";a="34926893"
Date: Mon, 18 Aug 2008 13:37:27 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "macro@linux-mips.org" <macro@linux-mips.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: one more apic merging preliminary series
Message-ID: <20080818203726.GB1152@linux-os.sc.intel.com>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com> <20080817124540.GF21434@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080817124540.GF21434@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 05:45:40AM -0700, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > Please review - any comments are welcome!
> >
> > For now it's like code bloating - but it's just preliminary series to
> > make apic_*.c code more or less similar. And it's still a bit far from
> > being ready to be merged down.
> 
> applied to tip/x86/apic - thanks Cyrill.
> 
> Maciej's point about cleaning up the x2apic impact is very much true -
> i've Cc:-ed Suresh and Venki. Even if we wont truly use x2apic in 32-bit
> kernels, it's a piece of glue hardware that does not depend on which
> mode the CPU is in, so support for it should be bitsize agnostic. It
> will also obviously be good for test coverage, once x2apic capable hw
> will be more widespread.

Interrupt-remapping(part of chipset) must be enabled before enabling/using
x2apic mode.

So, there is little bit more work (adding the intr-remapping pieces to 32bit
kernel etc) to be done, before enabling x2apic for 32-bit kernel aswell.

I am planning to do some work (introduce some kind of interrupt-remapping ops
and cleanup some of the code in the existing io_apic_64.c), that will
eventually make it easy to add interrupt-remapping and x2apic to 32bit aswell.

thanks,
suresh
