Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbZJVP4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbZJVP4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZJVP4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:56:49 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44430 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZJVP4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:56:48 -0400
Subject: Re: [PATCH 3/5 v4] Export memory_sysdev_class
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4AE07AB7.2070901@austin.ibm.com>
References: <4ADF1C49.2030201@austin.ibm.com>
	 <4ADF1E42.3020907@austin.ibm.com> <1256141009.23737.22.camel@nimitz>
	 <4AE07AB7.2070901@austin.ibm.com>
Content-Type: text/plain
Date: Thu, 22 Oct 2009 08:56:46 -0700
Message-Id: <1256227006.23737.784.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 10:31 -0500, Nathan Fontenot wrote:
> Dave Hansen wrote:
> > On Wed, 2009-10-21 at 09:44 -0500, Nathan Fontenot wrote:
> >> Export the memory_sysdev_class structure.  This is needed so we can create
> >> a 'release' file in sysfs in addition to the existing 'probe' file in
> >> order to support DLPAR removal of memory on the powerpc/pseries platform.
> >> The new 'release' file will be powerpc/pseries only.
> > 
> > Please do it in generic code.  You may only need it on ppc today, but
> > somebody else is going to want the same thing tomorrow on another arch.
> 
> I thought about this but wasn't sure if having the probe/release sysfs files
> for memory and cpu be in generic code would be accepted.

Although we don't want to pollute the generic code with lots of per-arch
cruft, this still looks pretty generic to me.  It is also really nice to
have all of the sysfs files for one directory be in a single place in
the source.

> Would it be acceptable to put the new release file for memory under the
> ARCH_MEMORY_PROBE config option?

That sounds fine to me.  It may need a slightly tuned name if you can
think of anything better.  I can't off the top of my head.

x86's is really only there for testing reasons.   I would use mem= to
shrink a machine's memory at boot then use the probe file to re-add it
later.  I did that before I had hardware that could do real hotplug.

> This would reduce the number of arch'es
> that would require stubs as it appears only powerpc and x86 define this.

Yeah, that'd be a nice side-effect I guess.

-- Dave

