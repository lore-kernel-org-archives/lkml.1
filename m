Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbYA3Woe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbYA3Woe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYA3WoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:44:23 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56624 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbYA3WoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:44:21 -0500
Subject: Re: Value of __*{init,exit} anotations?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <20080130223219.GT29368@does.not.exist>
References: <20080130200336.GN29368@does.not.exist>
	 <1201726817.3292.84.camel@localhost.localdomain>
	 <20080130212011.GA26621@uranus.ravnborg.org>
	 <1201729295.3292.94.camel@localhost.localdomain>
	 <20080130223219.GT29368@does.not.exist>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 16:44:12 -0600
Message-Id: <1201733052.3292.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 00:32 +0200, Adrian Bunk wrote:
> On Wed, Jan 30, 2008 at 03:41:35PM -0600, James Bottomley wrote:
> > On Wed, 2008-01-30 at 22:20 +0100, Sam Ravnborg wrote:
> > > On Wed, Jan 30, 2008 at 03:00:16PM -0600, James Bottomley wrote:
> >...
> > > > __init is possibly justifiable with a few hundred k savings on boot.
> > > > __devinit and the rest are surely killable on the grounds they provide
> > > > little benefit for all the pain they cause.
> > > For the embedded people a few kb here and there is worth it.
> > > 
> > > > all __exit seems to do is set us up for unreferenced pointers in
> > > > discarded sections, so could we kill that too?
> > > Again - savings when we build-in the drivers.
> > > And without the checks we see 'funny' linker errors on the architectues
> > > that can continue to add the .exit.text in /DISCARD/
> > 
> > Perhaps you have different figures, but my standard kernel linking ones
> > tell me that the discard sections only save tens of k (not hundreds that
> > the init ones save), so I really do think they have no real benefit and
> > land us huge problems of pointer references into discarded sections.
> > 
> > I don't deny we can invest large amounts of work to fix our current
> > issues and build large scriptable checks to ensure we keep it fixed ...
> > I'm just asking if, at the end of the day, it's really worth it.
> 
> Some people consider it worth it for their memory restricted systems
> and would like to drive the annotations even further. [1]
> 
> My experience while fixing section bugs during the last years is that 
> the __dev{init,exit}* are actually the main question since they are both 
> the majority of annotations and the ones that bring benefits only 
> in a case that has become very exotic (CONFIG_HOTPLUG=n).
> 
> All the other annotations either both bring value for everyone
> (plain __init* and __exit*) or are nothing normal drivers would
> use (__cpu* and _mem*).
> 
> People at linux-arch (Cc'ed) might be better at explaining how often 
> CONFIG_HOTPLUG gets used in real-life systems and how big the savings 
> are there.
> 
> That might be a good basis for deciding whether it's worth it.

I'll certainly buy this.  Perhaps killing everything other than __init
and __exit (meaning discardable whether the system is hotplug, suspend
or whatever) might get rid of 90% of the problem while still preserving
90% of the benefits.  I think a lot of the issues do come from confusion
over whether it should be __init, __devinint etc .

We can argue later over the benefit of __exit ...

James


