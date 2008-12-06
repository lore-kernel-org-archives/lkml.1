Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYLFVZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYLFVZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 16:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYLFVZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 16:25:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbYLFVZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 16:25:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sat, 6 Dec 2008 22:24:15 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061843.59495.rjw@sisk.pl> <alpine.LFD.2.00.0812060952100.3425@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812060952100.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812062224.16266.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of December 2008, Linus Torvalds wrote:
> 
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > So, to fix the issue at hand, I'd like the $subject patch to go first.  Then,
> > there is a major update of the new framework waiting for .29 in the Greg's
> > tree (that's the main reason why nobody uses it so far, BTW) and I'd really
> > prefer it to go next.  After it's been merged, I'm going to add the mandatory
> > suspend-resume things (save state and go to a low power state on suspend,
> > restore state on resume) to the new framework in a separete patch.
> > 
> > Is this plan acceptable?
> 
> Sounds good to me. And assuming Jesse/Greg are all aboard, I'll just wait 
> for the pull requests from Jesse and Greg.
> 
> The only thing I'll do right now is to send off my "print out ICH6+ 
> LPC resources" patch again to Jesse, with a changelog etc. It can probably 
> go in as-is (it really just adds printk's), but since it didn't matter 
> anyway we migth as well just do it as a PCI thing for 2.6.29 too.
> 
> On a similar note, I wonder what we should do about the whole "transparent 
> bridge resource allocation" thing. It also didn't end up really mattering, 
> even if it apparently made a difference for Frans. The question is just 
> whether we would be better off with IO windows for transparent buses (the 
> way we try to set things up now), or with a simpler PCI resource tree that 
> just takes advantage of the transparency.
> 
> The bridge windows _may_ result in better PCI throughput behind such a 
> bridge, so there is some argument for keeping them. On the other hand, 
> transparent bridges aren't generally for high-performance stuff anyway, 
> and one advantage of the transparency is the flexibility it allows (ie we 
> don't _need_ to set up the static bridging windows).

The static bridging windows help understand the system topology a bit IMO,
because you can just look at /proc/iomem and see what resources are
behind the bridge.

> I dunno. I wonder what Windows does. Following Windows in areas like this 
> tends to have the advantage that it's what the firmware and the hardware 
> has generally been tested with most. At the same time, I'm not sure this 
> is necessarily a very bug-prone area for either firmware or hardware. If 
> there's actual bridge bugs wrt the windows, I suspect such a bridge would 
> be broken enough to be unusable regardless.

I think Intel people should be able to find out what Windows does in this
area.

Thanks,
Rafael
