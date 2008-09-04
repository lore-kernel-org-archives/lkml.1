Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYIDXEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYIDXEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYIDXEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:04:44 -0400
Received: from gw.goop.org ([64.81.55.164]:60565 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbYIDXEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:04:43 -0400
Message-ID: <48C06989.6080307@goop.org>
Date: Thu, 04 Sep 2008 16:04:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org>  <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>  <48B76CE0.5010309@goop.org>  <20080829102547.655440bf@lxorguk.ukuu.org.uk>  <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com>  <Pine.LNX.4.64.0808291120540.8561@blonde.site>  <b170af450808290454m2f349ce3w4f400b0df0e105a2@mail.gmail.com>  <48B7E6EE.9090901@tuffmail.co.uk>  <Pine.LNX.4.64.0808291413260.12571@blonde.site>  <b170af450808291039u7d036313x49acdaec079e6213@mail.gmail.com> <b170af450809041242n43a6ef70s47a2e3e068619af0@mail.gmail.com> <Pine.LNX.4.64.0809042056270.3012@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0809042056270.3012@blonde.site>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Well.
>
> Thanks for the prod, and I'm certainly remiss for not following
> up sooner.  But I'm really not at all keen on such a patch going
> into mainline myself.
>   

I have my original patch with your changes as a followup patch sitting
in my queue.  I was planning on sending it in the next day or so.  I was
planning on adding the memory size parameter too.

> It's an interesting experiment, and I'd be happy to see such a patch
> (adjusted to make sure output goes to kerneloops.org) spending a little
> while in Fedora Rawhide (who'd be the right contact for that?).
>   

Dave Jones?  He used to do it, at least.  I guess a WARN_ON() would get
picked up by kerneloops.

> But so far as mainline goes, I share Alan Cox's opinion that we should
> not be chopping pages out of every x86 user's memory, just because a
> couple of machines with faulty BIOSes have been observed.
>   

I think that's a worthwhile cost for -rc.  We can fix it up (ie, make it
a real config option, defaulting off) for release once we're happy that
we understand the scope of the problem.

> Particularly now it's evident that the 64kB "limit" is no more than a
> reflection of where the directmap pagetable changes have caught such
> corruption.
>   

We should definitely make the kernel parameter set the banned memory
size so we can experiment with different cutoffs.

> If lots more such corruptions are reported, of course I would change
> my position; but those bad directmap PMD crashes are themselves quite
> recognizable now we know to look out for them.
>
> I would prefer you both to use the minimal memmap= solutions for now;
> but others may disagree.
>   

The fact that we're seeing this problem in two completely different
systems with different BIOSes and everything else makes me worried that
this is quite widespread.  It's only the persistence and diligence of
our bug reporters that we managed to work out that they're the same
problem.  How many other people are getting strange crashes and haven't
managed to correlate it any particular BIOS interaction?  Or just happen
to be corrupting memory we don't care about right now, but is only a
small code change or link order change away from disaster?

    J
