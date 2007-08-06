Return-Path: <linux-kernel-owner+w=401wt.eu-S1763315AbXHFJdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763315AbXHFJdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 05:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760791AbXHFJc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 05:32:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39592 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760752AbXHFJc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 05:32:57 -0400
Date: Mon, 6 Aug 2007 11:02:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
Message-ID: <20070806090210.GA15329@atrey.karlin.mff.cuni.cz>
References: <1184483593.1898.98.camel@caritas-dev.intel.com> <20070731110458.GA1777@elf.ucw.cz> <1185932071.1363.13.camel@caritas-dev.intel.com> <20070805185558.GE1758@elf.ucw.cz> <1186367486.527.5.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186367486.527.5.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Did the trick, I got the kernel to load, and it even attempted
> > exec... but I got doublefault (or what is it?)
> > 
> > Int 6: ... EIP: c4739906. Address is in reserve_bootmem_core.
> > 
> > Do I have to disable ACPI completely? I tried with acpi=off,
> > nosmp... but problem does not seem device related.
> 
> It seems that the problem has nothing to do with device or ACPI. Can you
> do a normal kexec? That is:
> 
> kexec -l <...>
> kexec -e
> 
> or 
> 
> kexec -p <...>
> ALT-SysRq-c to trigger a crash dump.

...that was indeed a problem. I can do successful kexec, as long as I
load bzImage (and not vmlinux). (Both kernels 2.6.22 and
2.6.23-rc2-git). Problem is, I can only load bzImage using -l, attempt
to load bzImage using -p results in 

"Could not find a free area of memory of 9000 bytes"
locate_hole failed

. Any ideas?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
