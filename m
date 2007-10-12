Return-Path: <linux-kernel-owner+w=401wt.eu-S934832AbXJLXTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832AbXJLXTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933381AbXJLXPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 19:15:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58295 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933944AbXJLXPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 19:15:48 -0400
Date: Fri, 12 Oct 2007 16:14:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: arch merge fallout.
In-Reply-To: <20071012225222.GD4290@redhat.com>
Message-ID: <alpine.LFD.0.999.0710121608460.6887@woody.linux-foundation.org>
References: <20071012035743.GA12897@redhat.com>
 <alpine.LFD.0.999.0710112103240.6887@woody.linux-foundation.org>
 <20071012182504.GA9222@redhat.com> <alpine.LFD.0.999.0710121457230.6887@woody.linux-foundation.org>
 <20071012221253.GB4290@redhat.com> <alpine.LFD.0.999.0710121542030.6887@woody.linux-foundation.org>
 <20071012225222.GD4290@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Oct 2007, Dave Jones wrote:
>
> Something I find useful is to just do for eg..
> 
> git log arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
> 
> from time to time, to figure out when certain changes happened,
> or even to grep for something in a changelog.
> With that file moved, git refuses to tell me about the log
> of a file that doesn't exist, and the log of the moved
> file in arch/x86 just has a single commit, detailing the move.
> 
> Is there an easy way to get the complete log of a file?

The "--follow" flag will follow renames when doing a log, so a simple

	git log --follow arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c

will do it.

[ Although I actually introduced a bug in that last week, so if it gives 
  empty output for you, add a "--stat" to get a diffstat (or "-p" to get 
  the whole patch) to work around a stupid mistake. That bug is in both 
  1.5.3.3 and 1.5.3.4 - and Junio happens to be away for two weeks, so 
  it's not fixed in any release yet. I have a trivial patch for it if you 
  care, but the "use -p" workaround is usually what you want to do anyway, 
  which is probably why  nobody even noticed it was broken! ]

			Linus
