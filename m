Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYDLVOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYDLVOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 17:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYDLVOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 17:14:03 -0400
Received: from keg.few.vu.nl ([130.37.24.4]:61885 "EHLO keg.few.vu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbYDLVOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 17:14:01 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Apr 2008 17:14:01 EDT
Date: Sat, 12 Apr 2008 23:05:44 +0200 (CEST)
From: Erik Bosman <ejbosman@cs.vu.nl>
X-X-Sender: ebn310@keg.few.vu.nl
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
In-Reply-To: <48012002.8030701@zytor.com>
Message-ID: <Pine.GSO.4.56.0804122252110.21756@keg.few.vu.nl>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
 <20080412124947.146865e4@laptopd505.fenrus.org> <48012002.8030701@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Apr 2008, H. Peter Anvin wrote:

> Arjan van de Ven wrote:
> >
> > Hi,
> >
> > why did you make this a configuration option? In general it's not
> > a good idea to make userspace visible ABI's (PR_* clearly is one of these)
> > a CONFIG option unless there's some HUGE space saving going on.
> > I don't see that here....
> >
> > So can you explain your rationale for making this a config option?
> >

The ABI itself is not a config option (see patch 1/3.)
If the x86 implementation patch isn't applied, prctl() will
return -EINVAL, just like most other PR_* options, which are
only implemented on specific architectures, take (PR_GET/PR_SET_ENDIAN)
as an example.

>
> I also saw no mention about performance impact, which need to be
> considered whenever *anything* is proposed to be inserted into a hot
> path.  It may be (heck, *should be*) that the performance impact isn't
> measurable, but that needs to be positively established.
>

This is why I made the implementation part configurable, although I don't
think the overhead will be very high since it seems to me that the
__switch_to_xtra function was designed explicitly to keep unusual options
out of the hot path.


