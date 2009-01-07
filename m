Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZAGLaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZAGLaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 06:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZAGLaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 06:30:00 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:43237 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbZAGLaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 06:30:00 -0500
Date: Wed, 7 Jan 2009 12:31:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Theodore Tso <tytso@mit.edu>, ccache@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090107113138.GA29730@uranus.ravnborg.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <496386EF.76E4.0078.0@novell.com> <20090106173300.GA10903@mit.edu> <49647B00.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49647B00.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 08:50:56AM +0000, Jan Beulich wrote:
> >>> Theodore Tso <tytso@mit.edu> 06.01.09 18:33 >>>
> >On Tue, Jan 06, 2009 at 03:29:35PM +0000, Jan Beulich wrote:
> >> >>> "Theodore Ts'o" <tytso@mit.edu> 06.01.09 16:15 >>>
> >> >In the short term, though, it would be nice if we could get back a
> >> >simple way of making a kernel  object file using just cc, so that ccache
> >> >and distcc could be functional again.   Does that seem reasonable?
> >> 
> >> Making the new logic dependent on a config option would seem reasonable
> >> to me - of course at the expense of the respective Makefile becoming
> >> even less readable.
> >
> >Too late.  :-) It's pretty unreadable already.... as a result, I'm not
> >at all confident that I could make such a patch.  Is this something
> >you could perhaps whip up?  I'd really appreicate it, as it would
> >seriously speed up by kernel development efforts.
> 
> Yes, I think I could (and in fact I already put it on my to-do list), but I can't
> give a good prediction on when I'd be able to get to it.

We only see the ccache/distcc issue if we have MODVERSIONS
enabled.
So if we introduce a CONFIG option to disable strip of modules
then we will have the double amount of configuration
possibilities.

Today we have with or without MODVERSION.
If we make the stripping configurable then we will have
in addition two different configurations.

The reason to do the .c -> .s -> .o step is to make the
__crc_ symbols local so we can strip them off.

What is the gain/pain ratio here?
Would it be a possibility to drop stripping off the
crc symbols and go back to the ld method that
is more ccache friendly?

We would still benefir from all the other stripping done - no?

	Sam
