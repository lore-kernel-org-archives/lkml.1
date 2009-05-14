Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZENVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZENVeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZENVeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:34:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60402 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZENVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:34:09 -0400
Date: Thu, 14 May 2009 23:34:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
Message-ID: <20090514213403.GB14741@elf.ucw.cz>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com> <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905141729180.30187@qirst.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-14 17:30:02, Christoph Lameter wrote:
> On Thu, 14 May 2009, Dave Hansen wrote:
> 
> > -	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
> > +	printk(KERN_ERR "No available memory %s: "
> > +			"kill process %d (%s) score %li or a child\n",
> >  					message, task_pid_nr(p), p->comm, points);
> 
> "No available memory" still suggests that plugging in more memory is the
> right solution.

And... on correctly working kernel, it is, right?

If you have no swap space and too many applications, you plug more
memory. (Or invent some swap).

If you misconfigured cgroups, you give more memory to them.

If your applications mlocked 900MB and you have 1GB, you need to plug
more memory.

So... when is plugging more memory _not_ valid answer? AFAICT it is
when it is some kernel problem, resulting in memory not being
reclaimed fast enough....
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
