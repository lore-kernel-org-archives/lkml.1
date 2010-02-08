Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0BHGyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:54:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49518 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab0BHGyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:54:33 -0500
Date: Mon, 8 Feb 2010 07:54:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: rostedt@goodmis.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Tromey <tromey@redhat.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       utrace-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       JimKeniston <jkenisto@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100208065425.GB1290@ucw.cz>
References: <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain> <m3636oh2rt.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain> <1264575134.4283.1983.camel@laptop> <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain> <1264600792.31321.464.camel@gandalf.stny.rr.com> <4B607B1A.3080007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B607B1A.3080007@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> Right, so you're going to love uprobes, which does exactly that. The
> >>> current proposal is overwriting the target instruction with an INT3 and
> >>> injecting an extra vma into the target process's address space
> >>> containing the original instruction(s) and possible jumps back to the
> >>> old code stream.
> >>
> >> Just out of interest, how does it handle the threading issue?
> >>
> >> Last I saw, at least some CPU people were _very_ nervous about overwriting 
> >> instructions if another CPU might be just about to execute them.
> > 
> > I think the issue was that ring 0 was never meant to do that, where as,
> > ring 3 does it all the time. Doesn't the dynamic library modify its
> > text?
> 
> No, it has nothing to do with ring.  It has to do with modifying code
> that another CPU could be executing at the same time, and with modifying
> code on the same processor through another virtual alias (they are
> different issues.)  The same issues apply regardless of the CPL of the
> processor.

...but these are always 'there could be cpu bugs around' issues,
right? Like amd k6. AFAICT x86 always supported self-modifying code
without any extra barriers needed...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
