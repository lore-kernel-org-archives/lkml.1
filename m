Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbYHMO3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbYHMO3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYHMO25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:28:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:37431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYHMO24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:28:56 -0400
Date: Wed, 13 Aug 2008 07:28:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: tvrtko.ursulin@sophos.com
Cc: "Adrian Bunk" <bunk@kernel.org>, davecb@sun.com,
       "Greg KH" <greg@kroah.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net, "Mihai Don??u" <mdontu@bitdefender.com>,
       "Pavel Machek" <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Message-ID: <20080813072859.752a4819@infradead.org>
In-Reply-To: <20080813141618.696833764EA@pmx1.sophos.com>
References: <20080813065401.1bbdcb07@infradead.org>
	<20080813141618.696833764EA@pmx1.sophos.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 15:16:12 +0100
tvrtko.ursulin@sophos.com wrote:

> Arjan van de Ven <arjan@infradead.org> wrote on 13/08/2008 14:54:01:
> 
> > > I am not sure what you are suggesting, and I may have missed the
> > > libmalware proposal (I don't see any mention of that specific
> > > idea in any other message).  However, just to be clear...  At no
> > > point did we suggest that the kernel would do any scanning.  What
> > > we have been interested in is a mechanism that can allow a
> > > scanning application to be notified by the kernel of specific i/o
> > > events, for those events to be blocked by the kernel until a
> > > user-space scan is done, and then the user-space scan sends back
> > > allow or deny, at which point the i/o event returns to the caller
> > > -- either success or error.  This is the only way that malware
> > > can be guaranteed of being detected when it is used (for local
> > > application purposes or for transmission to another platform) or
> > > created. 
> > 
> > this is a very broad statement that ignores the LD_PRELOAD approach,
> > and thus not true.
> 
> LD_PRELOAD does not solve at least knfsd and suid binaries. But we
> are going in circles. :)
>  
> > > Also, a solution that requires applications to be modified will
> > > not work, because there is no way that we would be able to get ALL
> > > applications on the machines to be modified in the required
> > > ways.  If ANY applications are not so modified, then you have an
> > > unacceptable
> > 
> > you don't need to modify applications to make them use a library...
> 
> Same is true for a kernel solution. Plus, it also works for those who
> make system calls directly, knfsd and suid binaries, and we can have
> cheap and ultra-efficient caching. Not much kernel code, even less
> complex kernel code and unmeasurable impact when not used and
> compiled in. What are the big technical objections to that?
> 

the biggest objection is the lack of security model description.
STILL nobody has answered Ted's questions.

And still the AV side of the argument keeps making circular arguments.


I'm not saying the kernel shouldn't be involved at all.
I can totally see a solution where we have a
sys_virus_scan(int fd)
that glibc calls at appropriate places (say every read() and mmap())
and that on the kernel side uses a cache to store which virus signature
version it was last scanned with, and if not new enough.. punts to some
userspace scanner for vetting.

but first someone needs to answer Ted's very basic questions or the
TALPA side really does look like a donkey in this argument.





-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
