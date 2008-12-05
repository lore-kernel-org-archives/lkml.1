Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYLEAVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYLEAVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYLEAUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:20:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53594 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbYLEAUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:20:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 01:20:01 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812050045.40928.rjw@sisk.pl> <alpine.LFD.2.00.0812041604400.3543@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812041604400.3543@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050120.02270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 of December 2008, Linus Torvalds wrote:
> 
> On Fri, 5 Dec 2008, Rafael J. Wysocki wrote:
> > > 
> > > Yes. And in the case of Frans' machine, the e1000e controller was before 
> > > all the bridges too.
> > 
> > Hm.  And unloading it before suspend made things work?  Interesting.
> 
> Yeah. Frans' workaround was
> 
>  - unloading e1000e before suspend
>  - using aggressive powersave setting on snd_hda_intel to ensure that
>    sound controller was already sleeping before entering suspend
> 
> and both of those devices are on the root PCI bus and are enumerated (and 
> thus resumed) before the transparent bridge.
> 
> So yeah, the whole "resource allocation for that bridge" saga should 
> _really_ not matter. But it clearly does seem to.

Well, I'm going to have a closer look at what we're doing to PCI bridges in the
resume code path, as this _feels_ relevant in this case.

Perhaps we're not doing something we're supposed to do (that already happened
for regular devices in the past) or we're doing something we're not supposed
to do.  Unfortunately, I'd have to dig into the PCI bridge spec for this
purpose and that will take time.  Still, I suspect that's worth doing, as
potentially the problem may affect a wide range of systems.

The fact that I have a box on which I can reproduce the problem should help
here. ;-)

Thanks,
Rafael
