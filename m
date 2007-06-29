Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbXF2UNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbXF2UNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXF2UNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:13:42 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4889 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbXF2UNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:13:41 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 29 Jun 2007 13:12:58 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andy Isaacson <adi@hexapodia.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
In-Reply-To: <20070629193954.GL9157@hexapodia.org>
Message-ID: <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0>
 <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007, Andy Isaacson wrote:

> On Thu, Jun 28, 2007 at 10:57:00PM -0400, Kyle Moffett wrote:
> > On Jun 28, 2007, at 14:49:24, Davide Libenzi wrote:
> > >So I implemented a rather quick hack that introduces a new mmap()  
> > >flag MAP_NOZERO (only valid for anonymous mappings) and the  vma   
> > >counter-part VM_NOZERO. Also, a new sys_brk2() has been introduced  
> > >to accept a new flags  parameter. A brief description of the  
> > >patches follows in the next emails.
> > 
> > Hmm, sounds like this would also need a "MAP_NOREUSE" flag of some  
> > kind for security sensitive applications.  Basically, I wouldn't want  
> > my ssh-agent pages holding private SSH keys to be reused by my web  
> > browser which then gets exploited :-D.
> 
> PGP at least (and I think GPG still) did overwrite keys before calling
> free(), and attempted to use mlock().  Looks like ssh-agent doesn't use
> mlock -- at least it hasn't in this case:
> % grep Lck /proc/`pidof ssh-agent`/status
> VmLck:         0 kB
> % ulimit -a | grep lock
> file size (blocks)         unlimited
> core file size (blocks)    0
> locked-in-memory size (kb) 32
> file locks                 unlimited
> 
> Requiring security-sensitive apps to use a new flag to get safe behavior
> is dangerous.  Better to be safe by default and turn on the
> less-safe-but-faster behavior for the cases that benefit from it.

Can you better explain what MAP_NOZERO would alter in such case?



> I still think that using uid in mm_struct is wrong, and some kind of
> abstraction is required.  I called this "free pool" in
> <20070628061911.GA16986@hexapodia.org>, but I think that name is
> misleading -- I am not proposing that this should be part of the
> management of free pages, but should be a label which abstracts "safe to
> share freed pages among" groups.  Then different SELinux protection
> domains would simply have different labels.

I think I answered this one at least a couple of times, but anyawy. First, 
that can be whatever cookie we choose. At the moment UID is used because 
it makes easier a fit into _mapcount. Second, SeLinux will be able to 
disable the feature on a per-process base, or globally.
Anything else?



- Davide


