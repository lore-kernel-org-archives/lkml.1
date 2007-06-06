Return-Path: <linux-kernel-owner+w=401wt.eu-S932254AbXFFNKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbXFFNKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 09:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbXFFNKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 09:10:08 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:48856 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755175AbXFFNKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 09:10:06 -0400
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200706041630.49316.agruen@suse.de>
References: <20070514110607.549397248@suse.de>
	 <200706041342.42178.agruen@suse.de> <20070604131242.GE1971@elf.ucw.cz>
	 <200706041630.49316.agruen@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 06 Jun 2007 09:09:57 -0400
Message-Id: <1181135397.3699.53.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 16:30 +0200, Andreas Gruenbacher wrote:
> On Monday 04 June 2007 15:12, Pavel Machek wrote:
> > How will kernel work with very long paths? I'd suspect some problems,
> > if path is 1MB long and I attempt to print it in /proc
> > somewhere.
> 
> Pathnames are only used for informational purposes in the kernel, except in 
> AppArmor of course.

I don't mean this as a flame, but isn't the above statement the very
crux of this discussion?  Why should AppArmor be different from the rest
of the kernel in its usage of pathnames (basis for decisions vs.
informational reporting to userspace)?  And if it is ok for AppArmor to
generate and use pathnames as its basis of decisions on each open, then
is it also ok for audit, inotify, and others to use them in the same
manner?  If the audit developers or inotify developers had come with
patches that used d_path or equivalent in the same manner as AppArmor,
don't you think they would have gotten the same resistance?  And if you
are truly trying to create a mechanism (in AppArmor) that you can
ultimately apply widely to the system (going beyond AppArmor's original
limited focus on a small set of network-facing daemons), aren't you
concerned about the implications of having to generate a pathname on
each open just to decide what to do?  Is this really the "path" you want
to take ;)?

Another question:  it seems like the read-only bind mount folks gave up
on propagating the vfsmounts down and switched to a rather different
approach (checking near the entry points, using mount writer counters).
So similarly, what makes AppArmor fundamentally different that it
wouldn't take a similar approach to what they are doing vs. propagating
the vfsmounts down?  Or do you think they made the wrong choice?  If so,
why?

Just trying to understand your position better...

-- 
Stephen Smalley
National Security Agency

