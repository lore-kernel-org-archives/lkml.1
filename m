Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZIKGHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZIKGHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZIKGHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:07:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57504 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbZIKGHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:07:34 -0400
Date: Fri, 11 Sep 2009 08:07:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney@caviumnetworks.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 02/10] x86: Convert BUG() to use unreachable()
Message-ID: <20090911060701.GA18740@elte.hu>
References: <4AA991C1.1050800@caviumnetworks.com> <1252627011-2933-2-git-send-email-ddaney@caviumnetworks.com> <4AA9A031.5000602@zytor.com> <alpine.LFD.2.01.0909101806110.3654@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909101806110.3654@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 10 Sep 2009, H. Peter Anvin wrote:
> 
> > On 09/10/2009 04:56 PM, David Daney wrote:
> > > Use the new unreachable() macro instead of for(;;);.  When
> > > allyesconfig is built with a GCC-4.5 snapshot on i686 the size of the
> > > text segment is reduced by 3987 bytes (from 6827019 to 6823032).
> > > 
> > > Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> > > CC: Thomas Gleixner <tglx@linutronix.de>
> > > CC: Ingo Molnar <mingo@redhat.com>
> > > CC: "H. Peter Anvin" <hpa@zytor.com>
> > > CC: x86@kernel.org
> > 
> > Acked-by: H. Peter Anvin <hpa@zytor.com>
> > 
> > ... although of course this clashes with Roland McGrath's 
> > patchset for the same thing which I applied earlier.  I have to 
> > say I like unreachable() in lower case better though...
> 
> I like David's version a bit better, since it takes care of more 
> architectures, and also because it avoids that butt-ugly special 
> case for gcc-4.4.1-RH-relase-10 backporting this feature.
> 
> I realize that the RH backport thing is good for testing now, but 
> at the same time, it really does look nasty. I wonder if we could 
> add some config-time compiler feature testing - so that you'd not 
> have a version test at all, but a CONFIG_BUILTIN_UNREACHABLE.
> 
> There are other cases where that kind of config-time testing could 
> be useful, and we could avoid doing various gcc checks dynamically 
> from within 'make' (along with checking for known-buggy versions 
> etc).
> 
> And yeah, it looks better in lower case. That said, I don't care 
> _that_ much, and people can fight it out.

Another detail that would be nice to be fixed is to propagate the 
unreachable() call into the !CONFIG_BUG case as well in 
asm-generic/bug.h.

That would kill dozens of !CONFIG_BUG compiler warnings and would 
make a dont-allow-warnings policy a possibility for random builds.

	Ingo
