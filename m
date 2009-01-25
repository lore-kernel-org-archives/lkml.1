Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZAYA52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZAYA52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 19:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZAYA5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 19:57:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbZAYA5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 19:57:18 -0500
Subject: Re: [RT] [RFC] simple SMI detector
From: Jon Masters <jcm@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lee Revell <rlrevell@joe-job.com>, linux-rt-users@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0901241716540.3424@localhost.localdomain>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
	 <75b66ecd0901231833j2fda4554sb0f47457ab838566@mail.gmail.com>
	 <alpine.LFD.2.00.0901241716540.3424@localhost.localdomain>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Sat, 24 Jan 2009 19:57:06 -0500
Message-Id: <1232845026.3990.71.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-24 at 17:30 +0100, Thomas Gleixner wrote:
> On Fri, 23 Jan 2009, Lee Revell wrote:
> > 
> > FYI the RTAI project has a patch to allow disabling of SMI:
> > 
> > https://listas.upv.es/pipermail/rtlinuxgpl/2007-April/000609.html
> 
> FYI, this patch should be removed from the internet archives and the
> author should be made liable for the damage which can happen when
> innocent users try to use it for fixing things which simply can not be
> fixed.

Well, we disagree on the remedy there (I personally thing "caveat
emptor", although European law might well differ in that regard), but I
think a warning is very much called for, especially where end users are
concerned. Let's be sure those following along the LKML archives
understand something:

1). You (the end user) don't want to disable SMIs on existing systems.
2). Doing so might prevent thermal management software, system
management software, BIOS implemented fixes, and other components from
operating.
3). BIOS vendors might need to be encouraged to reduce SMI overhead.
Once systems have been designed to rely on lots of SMI overhead, the
game has already been lost. No amount of user fiddling will adequately
fix that.

What we are interested in doing with things like smi_detector is
noticing when there is substantial overhead, so that we can politely ask
the vendors involved to implement alternative SMI handlers that have
less of a hit on RT performance - the only real solution involving no
SMIs is more expensive hardware with dedicated system management/thermal
management processors.

> >> .... disabled SMIs with RTAI code the latencies of cyclictest were
> >> good, but after about 20 minutes my system stopped working and now
> >> it does not even boot anymore. :( Any hint?
> >
> > Yeah. Buy a new CPU. You deep-fried your P4 because you disabled the
> > thermal protection.
> 
> Aside of this worst case scenario, disabling SMIs is problematic as
> SMI is used to emulate devices, to fix chip bugs and necessary for
> enhanced features.
> 
> The only reasonable thing you can do on a SMI plagued system is to
> identify the device which makes use of SMIs. Legacy ISA devices and
> USB are usually good candidates. If that does not help, don't use it
> for real-time :)

Indeed. This is why I wrote an smi_detector that sits in kernel space
and can be reasonably sure measured discrepancies are attributable to
SMI behavior. We want to log and detect such things before RT systems
are deployed, not have users actively trying to work around SMI overhead
after the fact.

Jon.


