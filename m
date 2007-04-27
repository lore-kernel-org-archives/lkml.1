Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbXD0RHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbXD0RHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbXD0RHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:07:06 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:31414 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbXD0RGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P+8gulKIc7FiuE0/o1X2jdDqexT6vg/u5ELc0yfvVgF3T/b2OoitL+IuNRCFGuj1cjmY1d8lVjo2hNux5H7js0iJkDMQ/tzEMw6rlsqAa3VFnWVerVaNzDGPWmRH1DhcTr7qLwFDgsQOnom4JRNEkdI/1MwgT88g3asGHLkzyBQ=
Message-ID: <c03d1bd00704271006h4af83a0p99c37c6416b4c846@mail.gmail.com>
Date: Fri, 27 Apr 2007 22:36:48 +0530
From: "Gautham Shenoy" <ego.lkml@gmail.com>
To: "Dominik Brodowski" <linux@dominikbrodowski.net>,
       "Dave Jones" <davej@redhat.com>,
       "Nish Aravamudan" <nish.aravamudan@gmail.com>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       Dhaval <dhaval.giani@gmail.com>
Subject: Re: [RFC] [PATCH] cpufreq: allow full selection of default governors
In-Reply-To: <20070427122444.GA3714@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704242057430.25153@server.thyself>
	 <20070424211253.GG23598@redhat.com>
	 <29495f1d0704241505p62140160o52d83e383106bf8e@mail.gmail.com>
	 <20070425000327.GG22267@redhat.com>
	 <20070427015410.GA9650@isilmar.linta.de>
	 <20070427060957.GA4726@redhat.com>
	 <20070427122444.GA3714@isilmar.linta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/07, Dominik Brodowski <linux@dominikbrodowski.net> wrote:
> On Fri, Apr 27, 2007 at 02:09:57AM -0400, Dave Jones wrote:
> > On Thu, Apr 26, 2007 at 09:54:10PM -0400, Dominik Brodowski wrote:
> >  > On Tue, Apr 24, 2007 at 08:03:27PM -0400, Dave Jones wrote:
> >  > > On Tue, Apr 24, 2007 at 03:05:36PM -0700, Nish Aravamudan wrote:
> >  > >  > On 4/24/07, Dave Jones <davej@redhat.com> wrote:
> >  > >  > > On Tue, Apr 24, 2007 at 09:03:23PM +0000, William Heimbigner wrote:
> >  > >  > >  > The following patches should allow selection of conservative, powersave, and
> >  > >  > >  > ondemand in the kernel configuration.
> >  > >  > >
> >  > >  > > This has been rejected several times already.
> >  > >  > > Ondemand and conservative isn't a viable governor for all cpufreq
> >  > >  > > implementations (ie, ones with high switching latencies).
> >  > >  >
> >  > >  > This piques my curiosity -- some governors don't work with some
> >  > >  > cpufreq implementations. Are those implementations in the kernel or in
> >  > >  > userspace? If in the kernel, then perhaps there should be some
> >  > >  > dependency expressed there in Kconfig between cpufreq implementation
> >  > >  > and the available governors
> >  > >
> >  > > it can't be solved that easily. powernow-k8 for example is fine to
> >  > > use with ondemand on newer systems, where the latency is low.
> >  > > On older models however, it isn't.
> >  > >
> >  > >  > > Also, see the
> >  > >  > > comment in the Kconfig a few lines above where you are adding this.
> >  > >  >
> >  > >  > Are these governors unfixable? If
> >  > >
> >  > > tbh, I've forgotten the original issues that caused the comment
> >  > > to be placed there. Dominik ?
> >  >
> >  > Not unfixable, but: cpufreq is currently[*] built around the assumption that
> >  > at least one governor is correctly initialized or can be brought to work
> >  > when a CPU is registered with the cpufreq core.
> >
> > It would have to take something fairly spectacular though for performance or
> > powersave to fail registration. Can you remember why we chose not to allow those?
>
> performance _is_ allowed; powersave would be possible -- but then those who
> accidentally enable it on elanfreq might wait 100 times as long for the
> system to boot, with gx-suspmod it might even be 255 times as long -- okay,
> by default it's just 20 times as long, but still...

I agree!

Let a stable governor like performance or userspace be the default to
get the cpufreq up and running during boot up, and later on have some
init script switch
to a preferred governor like powersave/ondemand/conservative.

Changing governor is just a matter of loading the appropriate module
and echoing the appropriate value into
/sys/devices/*/cpufreq/scaling_governor. Hardly takes any time.

William, Is there a specific reason why you would want
powersave/ondemand/conservative to be activate during the system boot
up?

>
>         Dominik
> -
Regards
gautham.
