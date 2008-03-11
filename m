Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYCKV73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYCKV73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYCKV7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:59:22 -0400
Received: from mail.crca.org.au ([67.207.131.56]:45389 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYCKV7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:59:21 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH -mm] kexec jump -v9
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080311211004.GA30164@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080311211004.GA30164@redhat.com>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Wed, 12 Mar 2008 08:59:18 +1100
Message-Id: <1205272758.7990.37.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I hope kexec turns out to be a good, usable solution. Unfortunately,
however, I still have some areas where I'm not convinced that kexec is
going to work or work well:

1. Reliability.

It's being sold as a replacement for freezing processes, yet AFAICS it's
still going to require the freezer in order to be reliable. In the
normal case, there isn't much of an issue with freeing memory or
allocating swap, and so these steps can be expected to progress without
pain. Imagine, however, the situation where another process or processes
are trying to allocate large amounts of memory at the same time, or the
system is swapping heavily. Although such situations will not be common,
they are entirely conceivable, and any implementation ought to be able
to handle such a situation efficiently. If the freezer is removed, any
hibernation implementation - not just kexec - is going to have a much
harder job of being reliable in all circumstances. AFAICS, the only way
a kexec based solution is going to be able to get around this will be to
not have to allocate memory, but that will require permanent allocation
of memory for the kexec kernel and it's work area as well as the
permanent, exclusive allocation of storage for the kexec hibernation
implementation that's currently in place (making the LCA complaint about
not being able to hibernate to swap on NTFS on fuse equally relevant). 

While this might be feasible on machines with larger amounts of memory
(you might validly be able to argue that a user won't miss 10MB of RAM),
it does make hibernation less viable or unviable for systems with less
memory (embedded!). It also means that there are 10MB of RAM (or
whatever amount) that the user has paid good money for, but which are
probably only used for 30s at a time a couple of times a day.

Any attempt to start to use storage available to the hibernating kernel
is also going to have these race issues.

2. Lack of ACPI support.

At the moment, noone is going to want to use kexec based hibernation if
they have an ACPI system. This needs to be addressed before it can be
considered a serious contender.

3. Usability.

Right now, kexec based hibernation looks quite complicated to configure,
and the user is apparently going to have to remember to boot a different
kernel or at least a different bootloader entry in order to resume. Not
a plus. It would be good if you could find a way to use one bootloader
entry, resuming if there's an image, booting normally if there's not.

Nigel

