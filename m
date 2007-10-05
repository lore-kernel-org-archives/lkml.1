Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbXJEXBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbXJEXBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761472AbXJEXBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:01:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:46627 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761412AbXJEXBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S36kh0uAovBz18mrl/VWvlOyjJoSBmBHyhoc0HRRqq9c34U5A9oOubM29nqjnVbhKTZs2INZfxid5i1A+yzesOhTl9hz4y9JDD4jIbWSFYANoIQNkDcO+ynygmPylRT7/w4gN1D7t0AjN0Ize6xC73ds8Pkj9G/qP2+Cn11bc80=
Message-ID: <653402b90710051601x347924d3j34b5ec740c39e81c@mail.gmail.com>
Date: Sat, 6 Oct 2007 01:01:10 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <200710051126.50816.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1191528247.13580.11.camel@grianne>
	 <200710042059.25721.rob@landley.net>
	 <653402b90710050001k29ed8e3by1ccc4a0ede818b9f@mail.gmail.com>
	 <200710051126.50816.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/07, Rob Landley <rob@landley.net> wrote:
> On Friday 05 October 2007 2:01:08 am Miguel Ojeda wrote:
> >
> > I think we all are trying to give ideas to improve the current logging API.
> >
> > If something works, it's great; but it doesn't mean that it can't be
> > improved, right?
>
> I'm all for improving the kernel, but my definition of "improved" does not
> include every possible change.  I balance "smaller and simpler" with "more
> features".  Complexity is a cost, we should get something in return.
>
> Making the same functionality simpler makes it "cheaper" from a development
> standpoint.  Smaller and simpler means less overhead, less to understand,
> less to go wrong.  It's also attractive to me personally, because I am a Bear
> of Very Little Brain and between the dozen or so projects I try to follow, I
> have trouble fitting all the details in my head when they're tricky or they
> change ever time I look at them.  (Especially when I get distracted from one
> of those projects for 3-6 months and come back to find it changed.)

I fully agree. However, I just gave away some ideas that I believe
they can make printk() easier and more understandable than it is right
now (for example, standardizing kprint_[registered,detected,...]
messages is something that I think it can simplify everyday use of
messages, both to people who has to code it, review/search the code
and people that reads the kernel output).

>
> I recognize constantly having to learn new things as part of the cost of
> living, and making things more complicated happens as you add features.  But
> when somebody reinvents the wheel it's really nice to have clearly spelled
> out the advantages of the new wheel vs the old one.  It's nice for there to
> _be_ clear advantages, offsetting the increased complexity cost.

I got your point, and I agree. However, I also see the possibilities
that a change of the logging API can bring: If someday it gets
improved, maybe such day should be improved as far as possible. This
kind of stuff that affect so many things are not going to change for
long periods of time, as you said.

Still, I know some kind of changes can be really complex and maybe are
unproductive. I think the point is to get a middle point between new
complexity vs. new features.

>
> In this case, upon asking, the only potential advantage here seems to be "now
> we can translate dmesg output into Chinese more easily", which is something

Well, other improvements suggested are not just about internationalization.

> you could already do in userspace already via regular expressions in a
> translating dmesg, and which has the primary effect of making the resulting
> dmesg useless to report to lkml without really improving the amount of sense
> it makes to nontechnical end users (who really aren't the target of the
> english dmesg output, either).  The "linux developer who can't read english"
> niche is inherently somewhat problematic, as has been discussed here before.
>

I didn't talk about internationalization (in fact, I think it is going
to be pretty complex to get it right and, worse, to get it up-to-date
in each release without error in translations)

> The cost of this patch is making the kernel bigger, the in-kernel printk api
> more complicated, and the userspace dmesg noticeably more complex just to
> implement the same functionality against the new API.  Documenting the
> changes is nice, but doesn't reduce this increase in complexity.
>
> The original idea (selectively compile out printk() instances based on log
> level to conserve space) is explicitly not addressed by this patch, and in
> fact this patch might actually make it harder to implement (by complicating
> the code).
>
> *shrug*  That doesn't mean my objections are important to anyone else, just
> that I don't personally see any reason to be enthusiastic about this patch.

Take a look to other suggested changes, maybe you like some of them
and you will have found a reason to be enthusiastic :)

>
> Rob

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
