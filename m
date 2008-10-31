Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbYJaLkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbYJaLkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYJaLkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:40:31 -0400
Received: from molly.corsac.net ([81.57.48.219]:40428 "EHLO molly.corsac.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbYJaLka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:40:30 -0400
Date: Fri, 31 Oct 2008 12:40:25 +0100
From: Yves-Alexis Perez <corsac@debian.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: Long delays and keystrokes required - related to disk
	encryption?
Message-ID: <20081031114025.GB10383@corsac.net>
References: <200810281744.52587.elendil@planet.nl> <20081030195031.GA22805@elf.ucw.cz> <200810310104.25932.elendil@planet.nl> <20081031075705.GA32689@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031075705.GA32689@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 08:57:05AM +0100, Pavel Machek wrote:
> On Fri 2008-10-31 01:04:25, Frans Pop wrote:
> > On Thursday 30 October 2008, Pavel Machek wrote:
> > > Try "nohz=off highres=off"...
> > 
> > Oh, I have no doubt that that could help. The point is though that I don't 
> > think I should have to use such parameters.
> > 
> > I think we've already established that disabling hires timers helps, so, 
> > unless this will provide some additional tracing info to the developers, 
> > I think I'll skip this suggestion.
> > 
> > 2.6 28-rc2 is a regression against 2.6.27 because hires is broken. I don't 
> > think I'll want to permanently add random boot parameters to work around 
> > that regression.
> 
> Well, you could probably narrow it down to "nohz=off", because I
> believe it is probably nohz and not highres that makes problems.
> 
> Anyway, if this does not get fixed soon, you should cc rjw so this
> gets on the regression list.

It already is on the regression list, see:

http://bugzilla.kernel.org/show_bug.cgi?id=11826
http://bugzilla.kernel.org/show_bug.cgi?id=11893
> 
> You can probably debug this with git bisect if no other ideas
> surface...

Bisect has already been done, the offending commit is:

commit dc4304f7deee29fcdf6a2b62f7146ea7f505fd42
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Mon Oct 13 10:32:15 2008 -0400
    rangetimers: fix the bug reported by Ingo for real


And workarounding it with a return; early in the function worked.
But that's not really a solution.

Cheers,
-- 
Yves-Alexis
