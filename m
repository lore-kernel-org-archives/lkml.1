Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbXA0CkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbXA0CkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 21:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbXA0CkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 21:40:22 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:44327 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751865AbXA0CkV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 21:40:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wq+ZFhtT9udU21ACigPpuEf1NsW63DmBGo6oVISeGjPCtH/p9qI2lSuwNcgPi8qt8s5tOLiJhrN0djWcleY9xvKxQKC4OTVvB2s/2RrOTAd0gMqlabl1JxAcZPT7iykhTVgbGAWvpRG8h5PcjNACSGpxTyXl4rJ5T5cvkqOK274=  ;
X-YMail-OSG: _yMFl5gVM1lZeP4xx0DUPaAooioOFNaTxbmBa6cyRBv.1wLpA.BKAO8K5.dplAqJJ.95YBlu5Ad7PTWLB5dPjEIzpWUEJKx1KgPhmdE8Fs.pz0PgNeq4SjVFVQ1Ozlo-
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Date: Fri, 26 Jan 2007 18:40:16 -0800
User-Agent: KMail/1.7.1
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <20061219185223.GA13256@srcf.ucam.org> <200701261642.56896.david-b@pacbell.net> <20070126165657.663358ab.akpm@osdl.org>
In-Reply-To: <20070126165657.663358ab.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701261840.17194.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > It's certainly the case that fixing those drivers would result in a 
> > > better long-term situation - however, nobody currently seems to have any 
> > > interest in doing so...
> > 
> > And the way these things work, unfortunately, is that merging your patch
> > would ensure nobody ever gets such interest.  Removing that "state" file
> > (and its bogus infrastructure) has already taken a few years too long.
> 
> No, we shouldn't just break stuff for our users in the hope that said
> breakage will force some other developer to come in and fix things later.

That's not what happened though.  From my perspective, what I see is some
software which chose to START using an interface that's been on its way
out for a few years now.  (And deservedly so; nobody has been able to
demonstrate that it's not been broken-as-designed since day one.)  That
broke the process which had been working to finally get rid of that broken
interface.

Don't the people writing such software have responsibilities too?  Like,
to not start using undocumented and unstable interfaces that have been
acknowledged as broken and on-the-way-out?  Joining some of the Linux PM
mailing list discussions over the past few years would have been good too,
especially ones where userspace-driven PM was the topic.  (I kept asking
for real world examples, and nobody had any.  Which, among other things,
suggests that tool Matthew is concerned with isn't at all well known...)

(Plus, keep in mind that this is not "breakage" in any conventional
sense of something not working.  There's no oopsing or slowdown.)


> We should revert the breakage-causing patch, with the expectation that its
> submitter will ensure that all prerequisites are in place before it is
> reapplied.

Well, Linus is the one who submitted the original patch to add the
late_suspend()/early_resume() mechanism ... and there have been a few
other patches fixing issues turned up by that patch.  Matthew objected
to one side effect of that.  The "bypass layers" part of his patch is
as clean a workaround as can be had, I suppose.


> > > As I've said before, I think it's unreasonable to cripple interfaces for 
> > > (mostly) aesthetic reasons without ensuring that equivalent 
> > > functionality already exists.
> > 
> > I don't recall anyone raising aesthetic concerns.  And bug-equivalence
> > has never been a goal of Linux.
> > 
> 
> Not breaking things for end-users is a goal.  Prime directive, indeed.

With limitations.  Any time a bug gets fixed, it will break software
that relies on that bug.  Like, hmm, this case...

We **STILL** haven't gotten solid information on the software that
broke.  From what I've heard on this list it would seem to be used
on certain Ubuntu systems, but even the _name_ of the utility has
never been mentioned.  When we asked for more details, what came
back was the information that the problem was really a handful of
wireless drivers.


> > > This patch restores useful functionality  
> > > without breaking the extra sanity checks that you've added. I appreciate 
> > > that it's not an interface that you want to support in the long term 
> > > (well, even the short term...),
> > 
> > You imply that it _was_ once supported, which is not true.  Like any
> > other bug (in this case "design bug"), it was there and could be abused.
> > And like some other bugs, fixing it can trigger complaints from (ab)users.
> 
> Could someone please explain in easy-to-understand terms what the
> real-world impact of this bug is upon our users?  How many are affected,
> and under what circumstances, and with what effects?

>From what I can see, a small subset of Ubuntu users will notice that
battery life on some laptops isn't as long as it might be.  Most of
that issue can be resolved by "rmmod $WLAN_DRIVER", a workaround with
a long and successful history in Linux.

- Dave

