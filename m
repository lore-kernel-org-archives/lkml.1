Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbXJDVWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbXJDVWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbXJDVWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:22:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40741 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758050AbXJDVWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:22:14 -0400
Date: Thu, 4 Oct 2007 14:21:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Chouquet-Stringer <mchouque@free.fr>
cc: Ollie Wild <aaw@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
In-Reply-To: <20071004204443.GA28483@bigip.bigip.mine.nu>
Message-ID: <alpine.LFD.0.999.0710041413020.23684@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <m3wsu2u7y6.fsf@bigip.mine.nu> <alpine.LFD.0.999.0710041023480.23684@woody.linux-foundation.org>
 <20071004204443.GA28483@bigip.bigip.mine.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Oct 2007, Mathieu Chouquet-Stringer wrote:
> 
> Anything else you'd like me to try?

Well, since others definitely don't see this, including me, and I can do 
things like 62MB exec arrays:

	[torvalds@woody linux]$ echo $(find /home/torvalds/) | wc
	      1  883304 63000962

without getting any overflows (much less just on the kernel sources, which 
is less than a megabyte of pathnames), I think it would be good if you 
were to just instrument the kernel and make it do a "printk()" when it 
returns E2BIG in fs/execve.c (or the NULL returns from get_arg_page()).

Just to figure out *which* test fails for you but apparently nobody else.

		Linus
