Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbZANBLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbZANBLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 20:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZANBLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 20:11:45 -0500
Received: from THUNK.ORG ([69.25.196.29]:45552 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbZANBLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 20:11:45 -0500
Date: Tue, 13 Jan 2009 20:11:38 -0500
From: Theodore Tso <tytso@mit.edu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Rientjes <rientjes@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090114011137.GC14730@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Evgeniy Polyakov <zbr@ioremap.net>,
	David Rientjes <rientjes@google.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net> <20090113224941.GA14730@mit.edu> <20090113230240.GA30192@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113230240.GA30192@ioremap.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:02:40AM +0300, Evgeniy Polyakov wrote:
> > As Alan has already pointed out to you:
> > 
> >    (echo XXXX > /proc/self/oom_adj ; exec /usr/bin/program)
> 
> Yes, I saw that in archive, but did not receive myself, so did not
> answer. This works in the above simple case, but if we dig a little bit
> into the case when there are children, parent has to live and not all
> children should be considered equal by the oom-killer, things change
> dramatially. And we can not change the sources. Well, in particaular my
> case we can, but it is not about the single system :)

I think you will find that most people are far more interested in
making sure we define consistent, usable interfaces --- and depending
on process names is a complete and total hack.  Justifying it by
claiming that we won't be able to change application source code, so
we have to use a hack, isn't going to get you very far.

The security implications alone are troubling; OK, so we make the
process name "sshd" privileged and exempt from the OOM killer.  What
happens if a user creates a program called sshd in their home
directory and executes it --- gee, it's protected from the OOM killer
as well.  It's just not going to fly.  Give up now.

If your argument is "we have to protect crappy closed source
applications where their programmers can't be bothered to change their
source code to use a proper interface", you're just going to get
laughed out of the room.

       		   	       	     	- Ted
