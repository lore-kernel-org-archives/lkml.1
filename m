Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYJaCit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYJaCit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 22:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYJaCih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 22:38:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:49456 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbYJaCig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 22:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q7JDTcJ336rjAVD9OdiuKeT5NEvh0/TBReNOVG36V+5Tis4lL5fDZybnX661GBtt31
         YcuxTtIkiSHK2/Ajo4Lf9mgZYSVazKBybSEHtjJ52CkXm6ixO/P5brA16RF3i6nAqWE6
         vmli6Gf0WiZGWQkJaM1QXrq6Yr7hxUk0Syei4=
Message-ID: <3aaafc130810301938k4ee654d6sf7de1fff5d9c9fc3@mail.gmail.com>
Date: Thu, 30 Oct 2008 22:38:36 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: merging other repos into linux-2.6
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0810301843220.21084@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081030054944.GA19035@kroah.com>
	 <3aaafc130810301834w554fbd33p6f423ffef77e92aa@mail.gmail.com>
	 <alpine.LFD.2.00.0810301843220.21084@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 9:47 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I don't think it's _hard_. But I think it does require some effort.

Right, my point is if this turns into a trend, will that effort be
well-spent? Or will it become too much of a pain to do all the time
and start making the history overly complex? I don't think the hard
part is in the import itself, but keeping up with more and more
imports that have to be done on a case-by-case basis, whereas patch
imports are automated already.

>
> Quite frankly, if it comes from CVS, I expect the logs, for example, to be
> totally inappropriate. I've never ever seen a CVS project that has sane
> commit messages (ok, so they're not "commits" in CVS, but you know what I
> mean).
>
> That's just one example. I'm not willing to pull history if it's full of
> crap. Pulling history for "history's sake" is worthless. The end result
> has to actually be meaningful and help _future_.

Yes, CVS is just braindead. I'm pretty sure we're on the same page
there. That's why I suggested the patch series idea. If we're less
interested in the actual date and time of the 'commit' and really just
interested in tracking and retaining contributor and change
information, then patches might be vastly easier, and they'll show up
as real git commits. So the commit date is messed up with respect to
when the CVS commit actually happened. Git already separates the
notion of 'author' and 'committer'... can we sanely separate the
notion of creation time (outside of tree) versus commit time (into
tree)?

If that separation is not acceptable and for some good reasons the
original commit dates and times *must* be preserved, then I freely
admit my idea is hare-brained and should be laughed off as the
ramblings of a young crackpot.

But I think it's a good middle-ground between a big-bang patch and
full-blown absorption of another project. From the looks of the
repository, there are less than 150 CVS commits for each driver file.
Most have less than 10. So per driver it would be a pretty short patch
series for the most part. And if Greg is tracking the CVS repo with
git, it would be fairly easy to create the series.

>
> So I strongly suspect that an "automated" history merge is simply not
> appropriate, and almost certainly results in an end result that is not up
> to snuff. And the question is whether anybody is willing to actually put
> in the effort to make the history actually be useful.

I agree. The only viable automated approach would be something akin to
git-submodule but with the ability to integrate the submodule'd
project upon import in such a way that things like bisection would
follow the main project's ancestry and ignore the submodule's. But
that's not possible right now and probably won't be in the foreseeable
future.

And the willingness to put in the effort may be there now, but what
I'm worried about is 6 months from now, when everyone who has an
out-of-tree driver wants history imported because "well, you did it
for the Comedi guys". Greg is a pretty busy guy, and we don't want him
buried under something like that, especially if the payoff is
marginal.

But hey, maybe if this is the direction we should go in, the tools to
automate it sanely will get written.

~J.R.
