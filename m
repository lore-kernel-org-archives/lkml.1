Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYIXWqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYIXWqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYIXWqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:46:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335AbYIXWqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:46:39 -0400
Date: Wed, 24 Sep 2008 15:45:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       tglx@tglx.de, mingo@elte.hu
Subject: Re: Warning/Oops report of the week of September 16th, 2008
In-Reply-To: <200809250036.47277.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0809241541320.3265@nehalem.linux-foundation.org>
References: <20080916092206.6342c498@infradead.org> <200809250036.47277.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Frans Pop wrote:
> 
> > Rank 6: parport_device_proc_register (warning)
> >         Reported 62 times (3942 total reports)
> >         Duplicate /proc registration in the parport driver
> >         This warning was last seen in version 2.6.26.3, and first seen
> >         in 2.6.24-rc5.
> 
> Note that I'm still seeing this in 2.6.27-rc7. This is now one of the 
> oldest entries in the list and as it happens for *every* print job, it's 
> quite an annoying one.
> 
> Unfortunately I still cannot get kerneloops to work for me.

Al and Arjan looked at this one at the KS, and quite frankly, the warning 
is just bogus.

Or rather, it's a warnign about the parport /proc interface. The fact is, 
the parport code can generate multiple "instances" of things that 
time-slice on the port, but they have all ended up always just registering 
under the same name. IOW, it's a bug in the _user_ interface, not the 
kernel.

I'd like to remove the file entirely (probably nobody uses it), but Al 
said he could perhaps send patches to extend it (yet leave the old name to 
point to the first instance, the way it always has). 

In the meantime, that warning is just best ignored entirely. It's not a 
kernel bug per se, or even anything that is fixable without changing 
exported user interfaces that in my opinion aren't necessarily even 
_worth_ changing (the only reasonable change is extending on the insane 
interface that nobody cares about).

I think Arjan agreed to just remove it from his statistics, but maybe he's 
just ignoring _new_ entries ;)

			Linus
