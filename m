Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbXDIRbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbXDIRbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXDIRbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:31:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47636 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753182AbXDIRbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:31:01 -0400
Date: Mon, 9 Apr 2007 12:30:53 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
Message-ID: <20070409173053.GD22997@lnx-holt.americas.sgi.com>
References: <20070409020600.6338BD82F4@pipsqueak.sf.frob.com> <m11wit34fo.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11wit34fo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK.  I just got the OK from management.  The system we were booting was
for research only.  We had NR_CPUS=num_online_cpus()=4096 which were
non-hyperthreaded.  With no attached I/O and the tweak I originally
posted plus one change Jack has already gotten accepted, the machine
booted in approx 12 minutes.

Thanks,
Robin


On Mon, Apr 09, 2007 at 10:20:27AM -0600, Eric W. Biederman wrote:
> Roland McGrath <roland@redhat.com> writes:
> 
> > I concur with Eric's assessment.  Adding new magic bits to the generic
> > clone path seems like a poor way to cope with kernel threads.  I think
> > it's better if kernel thread setup gets less like normal user process
> > setup.  I also agree with Eric that PPID of 0 is a very natural way for
> > kernel threads to be displayed.  We need to know more about the nature
> > of the compatibility issue in procps to judge whether there is good
> > reason to avoid changing it.
> 
> I just investigated the procps issue.  Using init_task as the parent
> nothing sticks out as being wrong in /proc.
> 
> Further when I modified pstree to accept 0 as it's starting pid (from
> which all else would be rooted).  All of the kernel threads showed up.
> 
> So if anything I it is a feature that kernel threads don't show up
> by default in pstree (when PPID == 0).  It isn't a subtle kernel bug.
> 
> Eric
