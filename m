Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbYLGEpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbYLGEpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 23:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYLGEpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 23:45:02 -0500
Received: from outbound-mail-33.bluehost.com ([69.89.18.153]:46522 "HELO
	outbound-mail-33.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753583AbYLGEpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 23:45:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=WW6k2SytdJ2CuFrChVaxdXTeqeBJHuzQWxqqFr3TgxizT6wVkTCA+I+Zs6oXbK+68Mwh2Lu9OrZugxETW9lo5G8A1Zpug0p0kyj4Npt1ypzGOObYycSGGSEGxTqr1OLt;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sat, 6 Dec 2008 20:44:57 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
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
Message-Id: <200812062044.57603.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 6, 2008 10:00 am Linus Torvalds wrote:
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > So, to fix the issue at hand, I'd like the $subject patch to go first. 
> > Then, there is a major update of the new framework waiting for .29 in the
> > Greg's tree (that's the main reason why nobody uses it so far, BTW) and
> > I'd really prefer it to go next.  After it's been merged, I'm going to
> > add the mandatory suspend-resume things (save state and go to a low power
> > state on suspend, restore state on resume) to the new framework in a
> > separete patch.
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

Ok, I applied the set (Rafael's 1-2 and your ICH patch) to my linux-next 
branch.  We should get a little build coverage this week at least, hopefully 
nothing breaks too badly.

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
>
> I dunno. I wonder what Windows does. Following Windows in areas like this
> tends to have the advantage that it's what the firmware and the hardware
> has generally been tested with most. At the same time, I'm not sure this
> is necessarily a very bug-prone area for either firmware or hardware. If
> there's actual bridge bugs wrt the windows, I suspect such a bridge would
> be broken enough to be unusable regardless.

Just so happens that I'm working with some people internally on transparent 
bridge related issues atm, I'll see what I can dig up.

-- 
Jesse Barnes, Intel Open Source Technology Center

