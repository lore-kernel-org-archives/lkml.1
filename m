Return-Path: <linux-kernel-owner+w=401wt.eu-S2992867AbXCIBQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992867AbXCIBQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 20:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992865AbXCIBQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 20:16:11 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:41510 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992872AbXCIBQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 20:16:10 -0500
Date: Fri, 9 Mar 2007 02:16:08 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Sam Vilain <sam@vilain.net>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, pj@sgi.com,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070309011608.GF4506@MAIL.13thfloor.at>
Mail-Followup-To: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
	Sam Vilain <sam@vilain.net>, ckrm-tech@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, xemul@sw.ru, pj@sgi.com,
	ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
	Paul Menage <menage@google.com>, akpm@linux-foundation.org
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <45EF5DB9.50606@vilain.net> <20070308113054.GB29051@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308113054.GB29051@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 05:00:54PM +0530, Srivatsa Vaddagiri wrote:
> On Thu, Mar 08, 2007 at 01:50:01PM +1300, Sam Vilain wrote:
> > 7. resource namespaces
> 
> It should be. Imagine giving 20% bandwidth to a user X. X wants to
> divide this bandwidth further between multi-media (10%), kernel
> compilation (5%) and rest (5%). So,

sounds quite nice, but ...

> > Is the subservient namespace's resource usage counting against ours too?
> 
> Yes, the resource usage of children should be accounted when capping
> parent resource usage.

it will require to do accounting many times
(and limit checks of course), which in itself
might be a way to DoS the kernel by creating
more and more resource groups
> 
> > Can we dynamically alter the subservient namespace's resource
> > allocations?
> 
> Should be possible yes. That lets user X completely manage his
> allocation among whatever sub-groups he creates.

what happens if the parent changes, how is
the resource change (if it was a reduction)
propagated to the children?

e.g. your guest has 1024 file handles, now
you reduce it to 512, but the guest had two
children, both with 256 file handles each ...

> > So let's bring this back to your patches. If they are providing
> > visibility of ns_proxy, then it should be called namesfs or some
> > such.
> 
> The patches should give visibility to both nsproxy objects (by showing
> what tasks share the same nsproxy objects and letting tasks move across
> nsproxy objects if allowed) and the resource control objects pointed to
> by nsproxy (struct cpuset, struct cpu_limit, struct rss_limit etc).

the nsproxy is not really relevant, as it
is some kind of strange indirection, which
does not necessarily depict the real relations,
regardless wether you do the re-sharing of
those nsproies or not .. let me know if you
need examples to verify that ...

best,
Herbert

> > It doesn't really matter if processes disappear from namespace
> > aggregates, because that's what's really happening anyway. The only
> > problem is that if you try to freeze a namespace that has visibility
> > of things at this level, you might not be able to reconstruct the
> > filesystem in the same way. This may or may not be considered a
> > problem, but open filehandles and directory handles etc surviving
> > a freeze/thaw is part of what we're trying to achieve. Then again,
> > perhaps some visibility is better than none for the time being.
> > 
> > If they are restricted entirely to resource control, then don't use
> > the nsproxy directly - use the structure or structures which hang
> > off the nsproxy (or even task_struct) related to resource control.
> 
> -- 
> Regards,
> vatsa
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
