Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYFWOhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYFWOhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbYFWOhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:37:09 -0400
Received: from mx.treblig.org ([80.68.94.177]:39065 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbYFWOhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:37:08 -0400
Date: Mon, 23 Jun 2008 15:37:06 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmap_min_addr/SECURITY_DEFAULT_MMAP_MIN_ADDR suggested values
Message-ID: <20080623143706.GF846@gallifrey>
References: <20080623135337.GE846@gallifrey> <20080623070435.76c8b260@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623070435.76c8b260@infradead.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.23.1-bytemark-uml (i686)
X-Uptime: 15:24:50 up 12 days, 21:53,  1 user,  load average: 0.09, 0.14, 0.07
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Mon, 23 Jun 2008 14:53:37 +0100
> "Dr. David Alan Gilbert" <linux@treblig.org> wrote:
> 
> > Hi,
> >   The config help for SECURITY_DEFAULT_MMAP_MIN_ADDR suggests 65536
> > as a 'reasonable' value for x86 and the original mmap_min_addr
> > patches suggested that 'something like 64k' was a safe value that
> > wouldn't affect most programs.
> > 
> >   Where does this 64k value come from?  A number of distros seem
> > to have followed this advice and have it set to 64k; but is there
> > really any likely benefit of having it larger than PAGE_SIZE say?
> 
> there's a few things in the kernel that are bigger than 4K (or rather,
> lead to pointers beyond 4K) so it's not all that bad advice.

Hmm OK.

> > I ask because I have an ancient program that maps stuff at 8k; the
> > general advice of stuff on the net seems to be to set this limit
> > to 0 if people have problems (I'm just lowering it to 4k),
> > but I was thinking perhaps using a lower default value would be more
> > secure since less people would take the easy answer and just turn the
> > feature off altogether.
> 
> interesting... what does the program do?

It's an emulator mapping an ancient binary at it's original load address.

> (applications making assumptions on where they can mmap stuff... that's
> not really valid. Realistically, the only safe way to use MAP_FIXED is
> on memory that you got from mmap before.. think about it: what if
> glibc happened to mmap something there first?)

If you don't have address space randomisation and break randomisation
(both of which you can turn off by personality flags) then the 
allocation of VM is actually quite predictable; if you get your
application loaded fairly high up in memory then most stuff ends up
being allocated after that leaving a nice clear area below it.
(It's a pity that there is no way of setting address space randomisation
and break randomisation from ELF flags - it would be a lot easier than
having to ensure something already turned them off before you are run).

In general there are a few apps that really like to control what there
VM layout looks like; I realise they are a bit on the odd side but it
would be nice to leave room for those apps to do that.

(I realise you can do the same with the minimum mmap thing but only
with SELinux (which quite a lot of people still don't use) or by
granting CAP_SYS_RAWIO - which seems like a very odd choice of CAP.)

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
