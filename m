Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXJGKUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXJGKUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 06:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXJGKUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 06:20:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:58931 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbXJGKUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 06:20:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cs0x11Z7WUyw4IcRu7d/DmajgRDuQwyUouyncZTK4cMYNptr+axw/ij4L58RUl68E/gbxyOAZXpBUDzsX3zNXs1wiOzotZTag+j6ydVUa3oeiIy5cyIwZBDX/ovwkCVoVYkhpT1qWOf47FRu0Mqp71C7t7F0rZRPKGSZj6EF7qA=
Message-ID: <653402b90710070320he9ae364i40e47578440255c5@mail.gmail.com>
Date: Sun, 7 Oct 2007 12:20:05 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Cc: "Rob Landley" <rob@landley.net>, "Randy Dunlap" <randy.dunlap@oracle.com>,
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
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <20071005173405.7a28bc73@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1191528247.13580.11.camel@grianne>
	 <200710042059.25721.rob@landley.net>
	 <653402b90710050001k29ed8e3by1ccc4a0ede818b9f@mail.gmail.com>
	 <200710051126.50816.rob@landley.net>
	 <653402b90710051601x347924d3j34b5ec740c39e81c@mail.gmail.com>
	 <20071005173405.7a28bc73@freepuppy.rosehill>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> On Sat, 6 Oct 2007 01:01:10 +0200
> "Miguel Ojeda" <maxextreme@gmail.com> wrote:
>
> > On 10/5/07, Rob Landley <rob@landley.net> wrote:
> > > On Friday 05 October 2007 2:01:08 am Miguel Ojeda wrote:
> > > >
> > > > I think we all are trying to give ideas to improve the current logging API.
> > > >
> > > > If something works, it's great; but it doesn't mean that it can't be
> > > > improved, right?
> > >
> > > I'm all for improving the kernel, but my definition of "improved" does not
> > > include every possible change.  I balance "smaller and simpler" with "more
> > > features".  Complexity is a cost, we should get something in return.
> > >
> > > Making the same functionality simpler makes it "cheaper" from a development
> > > standpoint.  Smaller and simpler means less overhead, less to understand,
> > > less to go wrong.  It's also attractive to me personally, because I am a Bear
> > > of Very Little Brain and between the dozen or so projects I try to follow, I
> > > have trouble fitting all the details in my head when they're tricky or they
> > > change ever time I look at them.  (Especially when I get distracted from one
> > > of those projects for 3-6 months and come back to find it changed.)
> >
> > I fully agree. However, I just gave away some ideas that I believe
> > they can make printk() easier and more understandable than it is right
> > now (for example, standardizing kprint_[registered,detected,...]
> > messages is something that I think it can simplify everyday use of
> > messages, both to people who has to code it, review/search the code
> > and people that reads the kernel output).
> >
> > >
> > > I recognize constantly having to learn new things as part of the cost of
> > > living, and making things more complicated happens as you add features.  But
> > > when somebody reinvents the wheel it's really nice to have clearly spelled
> > > out the advantages of the new wheel vs the old one.  It's nice for there to
> > > _be_ clear advantages, offsetting the increased complexity cost.
> >
> > I got your point, and I agree. However, I also see the possibilities
> > that a change of the logging API can bring: If someday it gets
> > improved, maybe such day should be improved as far as possible. This
> > kind of stuff that affect so many things are not going to change for
> > long periods of time, as you said.
> >
> > Still, I know some kind of changes can be really complex and maybe are
> > unproductive. I think the point is to get a middle point between new
> > complexity vs. new features.
>
>
> The beauty of printk is it's current simplicity.  And even with that developers
> get it wrong.  The changes seem like added complexity with little real gain.
>
> Plus none of the changes address the issue of getting better information.
> The kernel is already so noisy that most distributions boot with the quiet
> flag to shut it up. So less messages is probably better!
>

I agree. On the one hand, some changes are complex (like "blocks"
implementation) and maybe they will not help at all. I'm not agreeing
with every change :)

On the other hand, the new tags (more standarized messages and
simplified code) and all the information given by the new syslog
retrieved from userspace (formatted messages => better information
possibly) can do a lot of good (and maybe even more in the future,
with a lot more stuff inside the kernel), without creating noise at
boot at all. That kind of changes I think they would do more good than
bad.

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
