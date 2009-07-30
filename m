Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZG3XRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZG3XRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZG3XRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:17:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36089 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbZG3XRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:17:15 -0400
Date: Thu, 30 Jul 2009 19:17:02 -0400
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: Warning during suspend with MS-7310 mainboard
Message-ID: <20090730231702.GA15520@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Langsdorf, Mark" <mark.langsdorf@amd.com>,
	Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
References: <1248936650.3313.6.camel@queen> <6453C3CB8E2B3646B0D020C11261327303620A01@sausexmb4.amd.com> <20090730164629.GC2593@redhat.com> <200907310837.23487.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907310837.23487.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 08:37:22AM +0930, Rusty Russell wrote:
 > On Fri, 31 Jul 2009 02:16:29 am Dave Jones wrote:
 > > On Thu, Jul 30, 2009 at 11:38:22AM -0500, Langsdorf, Mark wrote:
 > >  > I'll look into it.
 > >  > 
 > >  > First time I've had this bug reported, though.
 > >  > 
 > > 
 > > It's happening because the suspend code runs with interrupts disabled,
 > > and the powerpc workaround we do in the cpufreq suspend hook
 > > calls the drivers ->get method.
 > > 
 > > powernow-k8's ->get does an smp_call_function_single
 > > which needs interrupts enabled
 > 
 > Yeah, I was confused: my patch changed set_cpus_allowed_ptr() to
 > an smp_call_function.  If the latter is a bad idea with irqs disabled, the
 > former certainly was...

Right, the only reason reverting your change 'fixes' the problem is
that we don't have a BUG() in set_cpus_allowed_ptr to check for interrupts
being disabled.

hmm, does adding an equivalent check make sense?
cpufreq seemed to cope just fine when we used set_cpus_allowed_ptr,
but we might have just got lucky. As we were suspending in this path,
interaction from the scheduler is minimal. Other callers might not
be so lucky?

	Dave
 
