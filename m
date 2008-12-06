Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYLFSB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYLFSB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 13:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYLFSBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 13:01:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392AbYLFSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 13:01:16 -0500
Date: Sat, 6 Dec 2008 10:00:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
In-Reply-To: <200812061843.59495.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812060952100.3425@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061822.35763.rjw@sisk.pl> <alpine.LFD.2.00.0812060930490.3425@nehalem.linux-foundation.org> <200812061843.59495.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> 
> So, to fix the issue at hand, I'd like the $subject patch to go first.  Then,
> there is a major update of the new framework waiting for .29 in the Greg's
> tree (that's the main reason why nobody uses it so far, BTW) and I'd really
> prefer it to go next.  After it's been merged, I'm going to add the mandatory
> suspend-resume things (save state and go to a low power state on suspend,
> restore state on resume) to the new framework in a separete patch.
> 
> Is this plan acceptable?

Sounds good to me. And assuming Jesse/Greg are all aboard, I'll just wait 
for the pull requests from Jesse and Greg.

The only thing I'll do right now is to send off my "print out ICH6+ 
LPC resources" patch again to Jesse, with a changelog etc. It can probably 
go in as-is (it really just adds printk's), but since it didn't matter 
anyway we migth as well just do it as a PCI thing for 2.6.29 too.

On a similar note, I wonder what we should do about the whole "transparent 
bridge resource allocation" thing. It also didn't end up really mattering, 
even if it apparently made a difference for Frans. The question is just 
whether we would be better off with IO windows for transparent buses (the 
way we try to set things up now), or with a simpler PCI resource tree that 
just takes advantage of the transparency.

The bridge windows _may_ result in better PCI throughput behind such a 
bridge, so there is some argument for keeping them. On the other hand, 
transparent bridges aren't generally for high-performance stuff anyway, 
and one advantage of the transparency is the flexibility it allows (ie we 
don't _need_ to set up the static bridging windows).

I dunno. I wonder what Windows does. Following Windows in areas like this 
tends to have the advantage that it's what the firmware and the hardware 
has generally been tested with most. At the same time, I'm not sure this 
is necessarily a very bug-prone area for either firmware or hardware. If 
there's actual bridge bugs wrt the windows, I suspect such a bridge would 
be broken enough to be unusable regardless.

			Linus
