Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYANOKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYANOKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYANOKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:10:00 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41972 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbYANOKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:10:00 -0500
Date: Mon, 14 Jan 2008 15:09:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Message-ID: <20080114140910.GA8507@uranus.ravnborg.org>
References: <20080103442.621670000@suse.de> <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114135240.GA15357@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 02:52:40PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Thu, Jan 10, 2008 at 02:12:59PM +0100, Andi Kleen wrote:
> > > Adrian Bunk <bunk@kernel.org> writes:
> > > >
> > > > Technically you are the one who has to deal with problems in your 
> > > > patches, not the people pointing at the problems.
> > > 
> > > If you believe that my patch adds a new problem then please describe
> > > it clearly so that I can understand it.
> > 
> > Description:
> > - there are already __cpuinit* annotations in the kernel
> > - on UP kernels supporting suspend/resume, such annotated code
> >   currently gets freed after booting (and this works)
> > - with your patch applied, this code no longer gets freed
> 
> ok, i've dropped this patch from x86.git for now:
> 
>  Subject: x86: force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
>  From: Andi Kleen <ak@suse.de>
> 
> but longer-term, shouldnt these annotations be automated? We'll see a 
> constant stream of them, all around the clock as people regularly get it 
> wrong (because it's not intuitive).
Would be great to have them automated - just dunno how to do it.
Do you see a feasible way to do it?

Short term modpost etc. will be enhanced to be less dependent on the actual
configuration when performing the checks.
It should not matter if CONFIG_HOTPLUG_CPU is enabled or not when we check
the __cpuint annotations but this is how we see it today so far
too many faults slip through.

	Sam
