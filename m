Return-Path: <linux-kernel-owner+w=401wt.eu-S1763276AbZEHXOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763276AbZEHXOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZEHXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:14:23 -0400
Received: from mail.crca.org.au ([67.207.131.56]:53739 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZEHXOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:14:23 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200905090105.58243.bzolnier@gmail.com>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905082144.57955.bzolnier@gmail.com>
	 <1241819971.19600.288.camel@nigel-laptop>
	 <200905090105.58243.bzolnier@gmail.com>
Content-Type: text/plain
Date: Sat, 09 May 2009 09:15:25 +1000
Message-Id: <1241824525.19600.369.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2009-05-09 at 01:05 +0200, Bartlomiej Zolnierkiewicz wrote:
> On Friday 08 May 2009 23:59:31 Nigel Cunningham wrote:
> > Hi.
> > 
> > On Fri, 2009-05-08 at 21:44 +0200, Bartlomiej Zolnierkiewicz wrote:
> > > Please proceed to Plan B then.
> > > 
> > > Adding third core code framework to do the same thing is out of question
> > > (probably same should have been said about adding second one in the past).
> > 
> > Why? We have plenty of history of having multiple implementations of
> > things (slub, slab and slob...).
> 
> With all respect to sl*b developers but things such as sl*b etc. are on
> whole different level when it comes to complexity because their interactions
> with weird hardware configurations are quite limited.

No, it's apples with apples. The hibernation code we're talking about
doesn't do "interactions with weird hardware configurations". It does
the job of preparing a hibernation image, compressing and writing that
image to disk, showing the user what's going on and doing the reverse at
resume time.

> > > Moreover you will for sure hit much more regressions than you expect
> > > (I "love" seeing over and over again when people/companies get trapped
> > > into fallacy of superiority of their _own_ solution).
> > 
> > That's just wrong. TuxOnIce deliberately doesn't remove any of swsusp or
> > uswsusp so that there's no chance of users having regressions. It
> > provides the _option_ of being a drop in replacement for swsusp, but it
> > doesn't force users to take that option.
> 
> OK.  What is exactly your plan for transition and for swsusp removal then?

1) Add the TuxOnIce patches given and enable the compile time option for
replacing swsusp by default for a couple of releases.
2) If people find problems, tell them to try using swsusp (echo 0
> /sys/power/tuxonice/replace_swsusp and then try hibernating) and seek
the cause of the regression.
3) Once we're satisfied that there are no regressions or they're fixed,
prepare code to remove swsusp.

> > Regressions happen at the moment because TuxOnIce isn't included in
> > vanilla. Users update from one version of stable to the next or from one
> > version of head to the next and expect TuxOnIce to keep working, and it
> > doesn't always do that because of changes to the vanilla code that
> > require an updated patch.
> 
> I mean [u]swsusp -> TuxOnIce regressions.

I know. I think I dealt with that above.

> > > I really wouldn't consider teaming with Rafael to work on "swsuspOnTux"
> > > (evolving the in-kernel code while re-using chunks of TuxOnIce code) as
> > > a bad Plan B.  It has the potential of resulting in a solution clearly
> > > superior to all existing ones (TuxOnIce included).
> > 
> > If there are features in swsusp that TuxOnIce is lacking, or features to
> > uswsusp that TuxOnIce is lacking, please tell me what they are and I'll
> > implement them. In saying this, I don't deny that TuxOnIce code can
> > still be improved - there's a lot I'd still like to do.
> 
> Instead of new features I would rather see more effort being put into making
> the _core_ TuxOnIce (I mean patch #8 here) smaller (8 KLOC is still a lot,
> just to put things into the right perspective the current in-kernel content
> of kernel/power/ is 5.5 KLOC) and with more documentation inside the code.

Yeah, but those 2.5k extra lines get you more reliability and extra
functionality. They're not fat.

Regarding documentation - yes, I could put more in the code. That's an
area I want to improve too. I don't think, however, that it should be
considered a barrier to merging the code into vanilla now.

Nigel

