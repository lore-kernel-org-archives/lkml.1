Return-Path: <linux-kernel-owner+w=401wt.eu-S1752820AbYCLCNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752820AbYCLCNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYCLCNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:13:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:6809 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYCLCNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:13:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,483,1199692800"; 
   d="scan'208";a="305459515"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <1205272758.7990.37.camel@nigel-laptop>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080311211004.GA30164@redhat.com> <1205272758.7990.37.camel@nigel-laptop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Mar 2008 10:14:34 +0800
Message-Id: <1205288074.29875.22.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 12 Mar 2008 02:13:05.0438 (UTC) FILETIME=[9B7C23E0:01C883E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 08:59 +1100, Nigel Cunningham wrote:
> Hi all.
> 
> I hope kexec turns out to be a good, usable solution. Unfortunately,
> however, I still have some areas where I'm not convinced that kexec is
> going to work or work well:
> 
> 1. Reliability.
> 
> It's being sold as a replacement for freezing processes, yet AFAICS it's
> still going to require the freezer in order to be reliable. In the
> normal case, there isn't much of an issue with freeing memory or
> allocating swap, and so these steps can be expected to progress without
> pain. Imagine, however, the situation where another process or processes
> are trying to allocate large amounts of memory at the same time, or the
> system is swapping heavily. Although such situations will not be common,
> they are entirely conceivable, and any implementation ought to be able
> to handle such a situation efficiently. If the freezer is removed, any
> hibernation implementation - not just kexec - is going to have a much
> harder job of being reliable in all circumstances. AFAICS, the only way
> a kexec based solution is going to be able to get around this will be to
> not have to allocate memory, but that will require permanent allocation
> of memory for the kexec kernel and it's work area as well as the
> permanent, exclusive allocation of storage for the kexec hibernation
> implementation that's currently in place (making the LCA complaint about
> not being able to hibernate to swap on NTFS on fuse equally relevant).

As Eric said kexec need only to allocate memory during loading, not
executing.
 
> While this might be feasible on machines with larger amounts of memory
> (you might validly be able to argue that a user won't miss 10MB of RAM),
> it does make hibernation less viable or unviable for systems with less
> memory (embedded!). It also means that there are 10MB of RAM (or
> whatever amount) that the user has paid good money for, but which are
> probably only used for 30s at a time a couple of times a day.
> 
> Any attempt to start to use storage available to the hibernating kernel
> is also going to have these race issues.

I think this can be avoid such as preallocate some hard disk space (such
as a dedicate hibernating file, the block list are loaded by
kexec-tools).

> 2. Lack of ACPI support.
> 
> At the moment, noone is going to want to use kexec based hibernation if
> they have an ACPI system. This needs to be addressed before it can be
> considered a serious contender.

ACPI is the biggest challenge for kexec based hibernation. I will try to
deal with it. But for most people, ACPI is not a big issue. This is
hibernation, not suspend to RAM.

> 3. Usability.
> 
> Right now, kexec based hibernation looks quite complicated to configure,
> and the user is apparently going to have to remember to boot a different
> kernel or at least a different bootloader entry in order to resume. Not

No, the newest implementation need not to boot a different kernel or
different bootloader entry. You just use one bootloader entry, it will
resume if there's an image, booting normally if there's not. You can
look at the newest hibernation example description.

And the new method can even be used to load hibernation image of uswsusp
too.

> a plus. It would be good if you could find a way to use one bootloader
> entry, resuming if there's an image, booting normally if there's not.

Best Regards,
Huang Ying

