Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbYHTTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbYHTTPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYHTTPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:15:42 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:65370 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbYHTTPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:15:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=ANIQR6DrGueAKdxepMnvmDPB9h7x8zkWCzm3YOcQP1FMl9pQQ8axH/J0HtwvJHT0J0
         C5pIFWHgBeW3Vvk7za9L75gN7kiIZbdFGkOcSsHf6sySqcGtDZcbxKIGQFhjvnkpdEl3
         MwJasHDnWq6gfD2PiNEpn1RKHh/Ohoq+e5TlU=
Date: Wed, 20 Aug 2008 23:16:59 +0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: peter_e@gmx.net, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, Nadia Derbey <Nadia.Derbey@bull.net>,
       Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>,
       Pierre Peiffer <peifferp@gmail.com>, containers@lists.osdl.org
Subject: Re: [Bugme-new] [Bug 11381] New: default shmmax
Message-ID: <20080820191659.GA22591@x200.localdomain>
References: <bug-11381-10286@http.bugzilla.kernel.org/> <20080820120043.e6e7e436.akpm@linux-foundation.org> <20080820191257.GA22556@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820191257.GA22556@x200.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: adobriyan@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 11:12:57PM +0400,  wrote:
> On Wed, Aug 20, 2008 at 12:00:43PM -0700, Andrew Morton wrote:
> > 
> > (switched to email.  Please respond via emailed reply-to-all, not via the
> > bugzilla web interface).
> > 
> > On Wed, 20 Aug 2008 05:58:57 -0700 (PDT)
> > bugme-daemon@bugzilla.kernel.org wrote:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=11381
> > > 
> > >            Summary: default shmmax
> > >            Product: Other
> > >            Version: 2.5
> > >      KernelVersion: 2.6.26.2
> > >           Platform: All
> > >         OS/Version: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: enhancement
> > >           Priority: P1
> > >          Component: Other
> > >         AssignedTo: other_other@kernel-bugs.osdl.org
> > >         ReportedBy: peter_e@gmx.net
> > > 
> > > 
> > > I would like to request that the default shmmax setting be increased or the
> > > downsides of that be documented.  Allow me to explain.
> > > 
> > > I am with the PostgreSQL development team.  PostgreSQL is probably one of the
> > > few users of large amounts of SysV shared memory.  Users would usually want to
> > > configure anywhere between 10% and 50% of their physical RAM to be used as
> > > shared memory, which would translate to something on the order of gigabytes
> > > nowadays.  One of the uniformly annoying things about setting this up is that
> > > you need to reconfigure the Linux kernel to allow that.  sysctl is nice and
> > > all, but it still requires users to learn about operating system and kernel
> > > details, requires root access, and distros don't handle sysctl uniformly
> > > either.  Maybe there is even a good reason for that, but I couldn't find it,
> > > and at least I would like to learn it, so that we can pass that information on
> > > to our users.
> > > 
> > > I did some kernel version archeology and found out that up until kernels 2.2
> > > the shmmax setting appears to have been restricted by CPU-specific constraints,
> > > as indicated by the default setting being different across CPUs and being
> > > defined in an asm header.  The default setting on i386 was increased from 16 MB
> > > to 32 MB somewhere around 1998 in the kernel 2.0 line, and it remains at 32 MB
> > > in the latest kernel on all architectures.
> > > 
> > > Now one question is whether there is a space or time overhead involved with
> > > setting a high shmmax limit that isn't actually used.  If so, it would be
> > > interesting to know what that overhead is.  The feeling I get from browsing the
> > > kernel source code over time is that there was some management overhead and/or
> > > some restrictions about this in old kernels, but that nowadays it doesn't
> > > really seem to matter much anymore.  I suspect instead that this whole thing
> > > was just forgotten, because few applications use large amounts of shared
> > > memory.
> > > 
> > > So, if you want to do us a favor, could you please see about increasing the
> > > default shmmax setting to whatever the theoretical maximum is?
> > > 
> > 
> > I don't think anybody has even thought about the shmmax default in
> > years.  Sure, it might be time to reexamine that.
> > 
> > It would be useful to get distro input on this.  Do they override the
> > kernel default at boot time?  If so, what do they do?
> > 
> > 
> > Also, from a quick read it looks to me that shmmax is busted in the
> > non-init namespace.
> > 
> > clone_ipc_ns() calls shm_init_ns() which does
> > 
> > 	ns->shm_ctlmax = SHMMAX;
> > 
> > which a) fails to inherit the parent's setting and
> 
> This is debatable if such behaviour should be default, this makes one ipc_ns
> more ipc_ns than others.

Oh, I forgot for a moment, that mainline has hierarchical ipc_ns.

