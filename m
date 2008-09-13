Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYIMRei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYIMRei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 13:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYIMRea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 13:34:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2246 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751215AbYIMRe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 13:34:29 -0400
Date: Sat, 13 Sep 2008 19:34:19 +0200
From: Pavel Machek <pavel@suse.cz>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Andrey Mirkin <major@openvz.org>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 8/9] Introduce functions to restart a process
Message-ID: <20080913173418.GA8822@ucw.cz>
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1220439476-16465-2-git-send-email-major@openvz.org> <1220439476-16465-3-git-send-email-major@openvz.org> <1220439476-16465-4-git-send-email-major@openvz.org> <1220439476-16465-5-git-send-email-major@openvz.org> <1220439476-16465-6-git-send-email-major@openvz.org> <1220439476-16465-7-git-send-email-major@openvz.org> <1220439476-16465-8-git-send-email-major@openvz.org> <1220439476-16465-9-git-send-email-major@openvz.org> <20080903143248.GU14473@hawkmoon.kerlabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903143248.GU14473@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > @@ -233,6 +234,26 @@ ENTRY(ret_from_fork)
> >  	CFI_ENDPROC
> >  END(ret_from_fork)
> >  
> > +ENTRY(i386_ret_from_resume)
> > +	CFI_STARTPROC
> > +	pushl %eax
> > +	CFI_ADJUST_CFA_OFFSET 4
> > +	call schedule_tail
> > +	GET_THREAD_INFO(%ebp)
> > +	popl %eax
> > +	CFI_ADJUST_CFA_OFFSET -4
> > +	movl (%esp), %eax
> > +	testl %eax, %eax
> > +	jz    1f
> > +	pushl %esp
> > +	call  *%eax
> > +	addl  $4, %esp
> > +1:
> > +	addl  $256, %esp

Can we do something with naming here? resume usually means 'resume
from s2ram'...

> > diff --git a/cpt/rst_process.c b/cpt/rst_process.c
> > new file mode 100644
> > index 0000000..6d47f3c
> > --- /dev/null
> > +++ b/cpt/rst_process.c
> > @@ -0,0 +1,277 @@

....and you are not even consistent. Plus, rst_ will probably be
understood as a reset by most people.

Hmmm... your syscalls get fd. What happens if I pass something like
/proc/self/maps to them?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
