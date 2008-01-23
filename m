Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbYAWAgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbYAWAgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYAWAgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:36:32 -0500
Received: from www.tglx.de ([62.245.132.106]:33439 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYAWAgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:36:31 -0500
Date: Wed, 23 Jan 2008 01:35:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch
 series v3)
In-Reply-To: <20080122142147.GD19936@wotan.suse.de>
Message-ID: <alpine.LFD.1.00.0801221623210.3199@apollo.tec.linutronix.de>
References: <200801161114.239449000@suse.de> <200801181819.58675.ak@suse.de> <20080121164052.GA11364@elte.hu> <200801211813.45102.ak@suse.de> <alpine.LFD.1.00.0801221119180.3199@apollo.tec.linutronix.de> <20080122132355.GA24320@wotan.suse.de>
 <alpine.LFD.1.00.0801221439520.3199@apollo.tec.linutronix.de> <20080122142147.GD19936@wotan.suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, Andi Kleen wrote:
> According to you and Ingo "the global perspective" is to get
> simple stuff first in. But in this case you're doing the complicated
> (and worse the unfinished) stuff first which seems to be against
> your own principles.

No, the global perspective is to get a stable and reliable system,
which allows us to do new features like gbpages, PAT and whatever
comes up next in a clean way.

Your patches just shove another extra into the existing code base
without doing any consolidation work and without any consideration of
problems we need to urgently solve in this area.

Your only care is to get stuff merged which is interesting for you. I
can understand that, but it should be entirely clear to you as an
engineer that ignoring the existing problems and adding more (even
simple) stuff makes it more complex to consolidate and is nothing else
than bad engineering.

PAT is high on the requirements list, not because it's not complex (it
definitely is), but simply because Linux has a years long of backlog
(it's the only modern OS on the planet still not using PAT) and
hardware makers are stepping beyond the limits of MTRRs. There is an
increasing number of systems which don't work under Linux properly due
to the MTRR limitations, but work perfectly fine with other
OSs. Should we ignore that ?

While PAT is a 10 years old hardware feature, gbpages is a feature for
a brand new chip, which is not even available to mere mortals in a
useable form. And there is no real problem with not having gbpages for
some time. So where is the pressure to get that in? Just because it
can be done and happens to work on some test machine?

PAT patches have been around for years and nothing happened - while
the first time gbpages were submitted was 19 days ago by you.

Of all pending features, PAT has a priority simply because it
affects users. The lack of gbpages does not. We are not going to rush
PAT in before it is stable, but we hold everything off which
interferes with getting it to that point.

Please stop arguing around with the subtle undertone of us having no
clue about the topics. We looked into the whole set of pending issues,
including your gbpages patchset and we well understand the
implications. It is quite clear that we need to fix the underlying
system _before_ we add more things to it. That applies to PAT, CPA and
gbpages in the same way.

In the end all of those features will benefit from a consolidated
implementation.

It's up to you whether you help to get there sooner or just sit back
and argue in circles until others have done the hard work and you can
add gbpages.

Thanks,
	tglx
