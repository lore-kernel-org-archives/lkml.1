Return-Path: <linux-kernel-owner+w=401wt.eu-S1764245AbYEBO4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764245AbYEBO4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbYEBO4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:56:15 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40354 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406AbYEBO4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:56:14 -0400
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jirislaby@gmail.com, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080501153048.2a8d356f.akpm@linux-foundation.org>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
	 <20080501142305.77433e50.akpm@linux-foundation.org>
	 <481A3781.8080100@gmail.com>
	 <1209679559.14864.33.camel@localhost.localdomain>
	 <20080501153048.2a8d356f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 09:56:10 -0500
Message-Id: <1209740170.3121.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 15:30 -0700, Andrew Morton wrote: 
> On Thu, 01 May 2008 17:05:59 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Thu, 2008-05-01 at 23:34 +0200, Jiri Slaby wrote:
> > > On 05/01/2008 11:23 PM, Andrew Morton wrote:
> > > > On Thu,  1 May 2008 17:56:02 +0200
> > > > Jiri Slaby <jirislaby@gmail.com> wrote:
> > > > 
> > > >> megaraid_sas suspend and resume are inappropriatelly placed in
> > > >> __devinit section.
> > > > 
> > > > That's a box-killer, isn't it?
> > > 
> > > I think so -- the non-CONFIG_HOTPLUG ones.
> > 
> > CONFIG_HOTPLUG is only settable to 'n' if you're CONFIG_EMBEDDED which
> > has a zero set intersection with the users of megaraid, so in practical
> > terms, there's no actual box it could kill.
> 
> who suspends and resumes servers?

Well, IBM for one ... although you wouldn't have to try hard to convince
me that they do it just to annoy me.

> > this whole 
> > 
> > #if CONFIG_PM
> > define suspend resume
> > #else
> > set suspend resume methods to null
> > #endif
> > 
> > Is completely analagous to what we used to do with CONFIG_HOTPLUG before
> > we had the __dev.* sectional annotations.  Since the expanding
> > bureacracy is determined to keep the _dev.* sections 
> 
> ooh, that makes us sound really bad!  ("since the server-obsessed
> embedded-hating bloatmonkeys..."?)

Well, since the __dev.* sections according to the embedded folks are
worth about a page possibly two, the __dev.* value to them is minimal
(particularly as a lot of them have hotplug anyway for their compact
flash, USB and the like).

> > in spite of the pain,
> 
> What pain?  Other people write the dang patches for you!  Their main
> problem is getting them merged.

No, the problem is getting them reviewed.  Since everyone seems to have
section mismatch fatigue they all seem to land on me.

> > could we not at least make the machinery do something vaguely
> > useful and expand it to confine the pm routines to sections which can be
> > discarded if CONFIG_PM is n?
> 
> a) it would need to be discarded at link-time, ideally.

Yes, the same way the exit sections are: as linker discards.  We also
have the mechanics for runtime discards which is useful for modules

> b) worth investigating.  It might lead to lengthy chains of compilation
>    warnings though.

Yes ... but if it was worth the effort to unify all the handrolled
CONFIG_HOTPLUG stuff, it should be worth it for all the handrolled
CONFIG_PM code.

James


