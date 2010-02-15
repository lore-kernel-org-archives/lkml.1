Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0BOSpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 13:45:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab0BOSpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 13:45:21 -0500
Date: Mon, 15 Feb 2010 13:45:02 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, aris@redhat.com,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/4] nmi_watchdog: use a boolean config flag for compiling
Message-ID: <20100215184502.GN3062@redhat.com>
References: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
 <20100214165941.GA26329@elte.hu>
 <20100215175106.GM3062@redhat.com>
 <20100215181301.GB5119@lenovo>
 <20100215182117.GC5119@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215182117.GC5119@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 09:21:17PM +0300, Cyrill Gorcunov wrote:
> On Mon, Feb 15, 2010 at 09:13:01PM +0300, Cyrill Gorcunov wrote:
> ...
> > > Looking through the code, is there ever case where 'apic' is undefined?
> > > The arch_trigger_all_cpu_backtrace should match identically to the old nmi
> > > code, so I am stuck on how to fix this.
> > > 
> > > Thoughts?
> > > 
> > 
> > It looks familiar to one problem with HW breakpoints "Kconfig select"
> > issue Frederic fixed once not that long ago, if I recall correctly.
> > 
> > So due to select we choose to compile hw_nmi.c, but CONFIG_LOCAL_APIC
> > (or APIC on UP) is turned off. So apic.c is not compiled. And at stage
> > of linking we get unresolved symbol.


Hmm thanks for the feedback.  The code can handle CONFIG_LOCAL_APIC being
turned off.  I'll look more at the UP stuff.

> > 
> > I don't remember the details how Frederic fixed HW breakpoints "select"
> > issue, CC'ed :) But you may google to find it out.
> >
> 
> Here is what I mean http://patchwork.kernel.org/patch/67973/

I don't believe I have the same issue.  Thanks for the pointer.

Cheers,
Don
