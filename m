Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbXKUQGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbXKUQGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbXKUQGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:06:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:22105 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbXKUQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:06:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZvEkGWDtK/lAyKmuOb5vt4Ru18w5D6EVxaSW2a3OJm5ovzthQoZImzuhwOZnF7no5XVrh7bQt0cig+l+x8Pf+Yto4Xi/RiEG8IqyhbQJhYEdx6TPW/yGWlkzdqseAFaMUt8RbY9/ejKkFGIxRrLjLYvbISqm9KPdNrzOiTMNUgg=
Message-ID: <3ae72650711210806v1e7daa2fq729a7593def99ef7@mail.gmail.com>
Date: Wed, 21 Nov 2007 17:06:39 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: gitweb: kernel versions in the history (feature request, probably)
Cc: "J. Bruce Fields" <bfields@fieldses.org>, "Petr Baudis" <pasky@suse.cz>,
       linux-kernel@vger.kernel.org, git@vger.kernel.org
In-Reply-To: <20071121075217.GA1642@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071120142042.GA4157@ff.dom.local>
	 <20071120215904.GF1001@machine.or.cz> <47436E0F.6080003@o2.pl>
	 <20071121032009.GB4175@fieldses.org>
	 <20071121075217.GA1642@ff.dom.local>
X-Google-Sender-Auth: 2c2bf681d6592546
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 21, 2007 8:52 AM, Jarek Poplawski <jarkao2@o2.pl> wrote:
> On Tue, Nov 20, 2007 at 10:20:09PM -0500, J. Bruce Fields wrote:
> > On Wed, Nov 21, 2007 at 12:30:23AM +0100, Jarek Poplawski wrote:
> > > I don't know git, but it seems, at least if done for web only, this
> > > shouldn't be so 'heavy'. It could be a 'simple' translation of commit
> > > date by querying a small database with kernel versions & dates.
> >
> > If I create a commit in my linux working repo today, but Linus doesn't
> > merge it into his repository until after he releases 2.6.24, then my
> > commit will be created with an earlier date than 2.6.24, even though it
> > isn't included until 2.6.25.
> >
> > So you have to actually examine the history graph to figure this out
> > this sort of thing.
>
> Of course, you are right, and I probably miss something, but to be
> sure we think about the same thing let's look at some example: so, I
> open a page with current Linus' tree, go to something titled:
> /pub/scm / linux/kernel/git/torvalds/linux-2.6.git / history
>
> and see:
> 2007-10-10 Stephen Hemminger [NET]: Make NAPI polling independent ...
> and just below something with 2007-08-14 date.
>
> Accidentally, I can remember this patch introduced many changes, and
> this big interval in dates suggests some waiting. Then I look at the
> commit, and there are 2 dates visible, so the patch really was created
> earlier. Then I go back to:
> /pub/scm / linux/kernel/git/torvalds/linux-2.6.git / summary
>
> and at the bottom I can see this:
>
> ...
> tags
> 4 days ago      v2.6.24-rc3     Linux 2.6.24-rc3
> 2 weeks ago     v2.6.24-rc2     Linux 2.6.24-rc2
> 4 weeks ago     v2.6.24-rc1     Linux 2.6.24-rc1
> 6 weeks ago     v2.6.23         Linux 2.6.23
>
> which drives me crazy, because, without looking at the calendar, and
> calculator, I don't really know which month was 6 weeks ago, and 4
> days ago, either!
>
> So, I go to the: http://www.eu.kernel.org/pub/linux/kernel/v2.6/,
> do some scrolling, look at this:
> ChangeLog-2.6.23             09-Oct-2007 20:38  3.8M
>
> and only now I can guess, this napi patch didn't manage to 2.6.23.
> Of course, usually I've to do a few more clicks and reading to make
> sure where it really started.
>
> So, this could suggest this 2007-10-10 (probably stored with time
> too), could be useful here... but it seems, I'm wrong.
>
> Of course, this problem doesn't look so hard if we forget about
> git internals: I can imagine keeping a simple database, which
> could simply retrieve commit numbers from these ChangeLogs, and
> connecting this with gitweb's commit page as well... For
> performance reasons, doing it only for stable and testing, so with
> -rc 'precision' would be very helpful too.

The "plain" view of the patch has the "version" included:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=bea3348eef27e6044b6161fd04c3152215f96411

  From: Stephen Hemminger <shemminger@linux-foundation.org>
  Date: Wed, 3 Oct 2007 23:41:36 +0000 (-0700)
  Subject: [NET]: Make NAPI polling independent of struct net_device objects.
  X-Git-Tag: v2.6.24-rc1~1454^2~841

Is that what you are looking for?

Kay
