Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZA1Phj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZA1Phj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 10:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZA1Pha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 10:37:30 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49250 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZA1Ph3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:37:29 -0500
Date: Wed, 28 Jan 2009 09:37:17 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Waychison <mikew@google.com>,
       Andrew Morton <akpm@osdl.org>, linux-s390@vger.kernel.org,
       linux390@de.ibm.com
Subject: Re: [PATCH] c/r: define s390-specific checkpoint-restart code
Message-ID: <20090128153717.GA25153@us.ibm.com>
References: <20090116173633.GB8477@us.ibm.com> <497F3F9F.2000803@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497F3F9F.2000803@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> 
> 
> Serge E. Hallyn wrote:
> > Implement the s390 arch-specific checkpoint/restart helpers.  This
> 
> Thanks for the patch.
> 
> I will assume that the s390 specifics are correct...
> 
> > is on top of Oren Laadan's c/r code (which so far was x86_32-only)
> > submitted here: http://lkml.org/lkml/2008/12/29/38, plus two more
> > patches by Nathan Lynch to fix some 64-bit issues (see
> > https://lists.linux-foundation.org/pipermail/containers/2009-January/015313.html
> > and
> > https://lists.linux-foundation.org/pipermail/containers/2009-January/015314.html
> > ).
> 
> ckpt-v13 already has these two fixed.
> 
> > 
> > With these, I am able to checkpoint and restart simple programs as per
> > Oren's patch intro.  While on x86 I never had to freeze a single task
> > to checkpoint it, on s390 I do need to.  That is a prereq for consistent
> > snapshots (esp with multiple processes) anyway so I don't see that as
> > a problem.
> > 
> > Oren, should we be putting a byte at the front of the format to
> > specify the architecture?
> 
> If we add a field to 'struct cr_hdr_head', then we'll need arch-dependent
> code in a non-arch dependent source, to ensure that no two architectures
> choose the same value as an identifier.
> 
> Can we not use the 'machine' string fiels in 'struct cr_hdr_head' - and
> then additional classification can take place in cr_read/write_head_arch() ?

Huh, yes, I somehow missed that.

> > +#define DEBUG 1
> > +
> >  #include <linux/version.h>
> >  #include <linux/sched.h>
> >  #include <linux/ptrace.h>
> > diff --git a/checkpoint/restart.c b/checkpoint/restart.c
> > index 6b4cd75..f65a63e 100644
> > --- a/checkpoint/restart.c
> > +++ b/checkpoint/restart.c
> > @@ -8,6 +8,8 @@
> >   *  distribution for more details.
> >   */
> >  
> > +#define DEBUG 1
> > +
> >  #include <linux/version.h>
> >  #include <linux/sched.h>
> >  #include <linux/wait.h>
> > 
> 
> Probably unrelated ?

Yup.  Will send a new version inc. your changes and against
v13 later this week.

thanks,
-serge
