Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbXH2I6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbXH2I6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 04:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbXH2I56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 04:57:58 -0400
Received: from [212.12.190.168] ([212.12.190.168]:32856 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753336AbXH2I54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 04:57:56 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>, Keith Packard <keith.packard@intel.com>
Subject: Re: CFS review
Date: Wed, 29 Aug 2007 11:53:30 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <1188374249.21502.155.camel@koto.keithp.com> <20070829080417.GB19386@elte.hu>
In-Reply-To: <20070829080417.GB19386@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708291153.30539.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Keith Packard <keith.packard@intel.com> wrote:
> > Make sure the X server isn't running with the smart scheduler
> > disabled; that will cause precisely the symptoms you're seeing here.
> > In the normal usptream sources, you'd have to use '-dumbSched' as an X
> > server command line option.
> >
> > The old 'scheduler' would run an entire X client's input buffer dry
> > before looking for requests from another client. Because glxgears
> > requests are small but time consuming, this can cause very long delays
> > between client switching.
>
> on the old box where i've reproduced this i've got an ancient X version:
>
>   neptune:~> X -version
>
>   X Window System Version 6.8.2
>   Release Date: 9 February 2005
>   X Protocol Version 11, Revision 0, Release 6.8.2
>   Build Operating System: Linux 2.6.9-22.ELsmp i686 [ELF]
>
> is that old enough to not have the smart X scheduler?
>
> on newer systems i dont see correctly updated glxgears output (probably
> the GLX bug you mentioned) so i cannot reproduce the bug.
>
> Al, could you send us your 'X -version' output?

This is the one I have been talking about:

XFree86 Version 4.3.0
Release Date: 27 February 2003
X Protocol Version 11, Revision 0, Release 6.6
Build Operating System: Linux 2.4.21-0.13mdksmp i686 [ELF] 


I also tried the gears test just now on this:

X Window System Version 6.8.1
Release Date: 17 September 2004
X Protocol Version 11, Revision 0, Release 6.8.1
Build Operating System: Linux 2.6.9-1.860_ELsmp i686 [ELF] 

but it completely locks up.  Disabling add_wait_runtime seems to fix it.


Thanks!

--
Al

