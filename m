Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYDLVRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYDLVRy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 17:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYDLVRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 17:17:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42220 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYDLVRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 17:17:45 -0400
Date: Sat, 12 Apr 2008 14:12:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Erik Bosman <ejbosman@cs.vu.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
Message-ID: <20080412141246.3b4c127c@laptopd505.fenrus.org>
In-Reply-To: <Pine.GSO.4.56.0804122252110.21756@keg.few.vu.nl>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
	<20080412124947.146865e4@laptopd505.fenrus.org>
	<48012002.8030701@zytor.com>
	<Pine.GSO.4.56.0804122252110.21756@keg.few.vu.nl>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008 23:05:44 +0200 (CEST)
Erik Bosman <ejbosman@cs.vu.nl> wrote:

> 
> 
> On Sat, 12 Apr 2008, H. Peter Anvin wrote:
> 
> > Arjan van de Ven wrote:
> > >
> > > Hi,
> > >
> > > why did you make this a configuration option? In general it's not
> > > a good idea to make userspace visible ABI's (PR_* clearly is one
> > > of these) a CONFIG option unless there's some HUGE space saving
> > > going on. I don't see that here....
> > >
> > > So can you explain your rationale for making this a config option?
> > >
> 
> The ABI itself is not a config option (see patch 1/3.)
> If the x86 implementation patch isn't applied, prctl() will
> return -EINVAL, just like most other PR_* options, which are
> only implemented on specific architectures, take
> (PR_GET/PR_SET_ENDIAN) as an example.

that doesn't say why you made it an option still :)
Something like this (which looks like generally useful functionality)
should just be there unless there is a really high cost....

> 
> >
> > I also saw no mention about performance impact, which need to be
> > considered whenever *anything* is proposed to be inserted into a hot
> > path.  It may be (heck, *should be*) that the performance impact
> > isn't measurable, but that needs to be positively established.
> >
> 
> This is why I made the implementation part configurable, although I
> don't think the overhead will be very high since it seems to me that
> the __switch_to_xtra function was designed explicitly to keep unusual
> options out of the hot path.

so you normally don't have performance overhead unless you use the feature....
that's really good!
It also means that there wouldn't be a need for this to be a config option, but
instead it can just always be there.. saving us a ton of ifdefs as well as the burden
of having an extra config option.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
