Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965Ab0ADRY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab0ADRY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130Ab0ADRYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:24:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49867 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab0ADRYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:24:54 -0500
X-Authority-Analysis: v=1.0 c=1 a=wwQKETDKjd0A:10 a=pGLkceISAAAA:8 a=hBqU3vQJAAAA:8 a=2C6YHBdLAAAA:8 a=VwQbUJbxAAAA:8 a=nMy-gVQoAAAA:8 a=rsJS0F8cAAAA:8 a=2PkAbkqWrFRAT7wTqBUA:9 a=jX9zoQDbL65aInZet8sA:7 a=_gmoheypb3UCV7oCx94f5WDiracA:4 a=MSl-tDqOz04A:10 a=4gZ4WExUoD4A:10 a=mJMriH8CDpcA:10 a=T5WE1YIYFGkA:10
X-Cloudmark-Score: 0
X-Originating-IP: 70.124.57.33
Date: Mon, 4 Jan 2010 11:38:10 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Ashwin Ganti <ashwin.ganti@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Eric Van Hensbergen <ericvh@gmail.com>
Subject: Re: Staging tree status for the .33 kernel merge
Message-ID: <20100104173810.GA29169@hallyn.com>
References: <20091223005447.GA28941@kroah.com> <20100104065755.GA26627@hallyn.com> <a67e66b21001040916g1f70ae0eqfb66c77394251b2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a67e66b21001040916g1f70ae0eqfb66c77394251b2b@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ashwin Ganti (ashwin.ganti@gmail.com):
> On Sun, Jan 3, 2010 at 10:57 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Quoting Greg KH (greg@kroah.com):
> > ...
> >> This means, unless someone steps up and starts doing real work (not
> >> trivial spelling fixes) on the following drivers, they will be removed
> >> in the future kernel releases.
> >>
> >> ?- arlan, netwave, strip, wavelan - wireless drivers mentioned above
> >> ? ?that are on the way out. ?Slated for removal in 2.6.35
> >> ?- hv - Microsoft Hyper V drivers. ?The developers again seem to have
> >> ? ?disappeared, this is getting old. Slated for removal in 2.6.35
> >> ?- p9auth - this will be removed in .34 unless someone steps up.
> >
> > I think I've decided to try to push it. ?I'm working with some patches
> > at git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux-cr.git
> > (branch p9auth.jan3.4 is latest). ?I'll send patches as I feel they
> > are ready - so far they pass testcases, but are too new for me to
> > feel I should push them today.
> 
> Thanks Serge!
> 
> It is useful to continue to have this driver in the tree as there a
> few other people as well who have shown interest in using this. I have
> been recently contacted by guys at Glendix (http://www.glendix.org/)
> who have started looking at using this driver.
> 
> >
> > Ashwin, I'm curious whether you'd think the last patch
> > (http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/sergeh/linux-cr.git;a=commitdiff;h=1662ba777140a39c21a9b647459d2deab8ffe1ca)
> > would be a problem with any userspace - but I assume there is no
> > legacy userspace to really worry about?
> 
> There is no legacy user space support yet for Linux. This should be
> fine in that sense.
> I still need to look at the patches in detail though but what is the
> motivation for this change?

Well, to have a login daemon be unprivileged, it needs some way to
set groups without CAP_SETGID.  I was playing with some toy frontend
and backend (i.e. login and factotum) code and this seemed a nice
simple way to do it.

> Please also cc rsc@swtch.com and ericvh@gmail.com as well when you
> send out these patches for review.

Will do, thanks.

> > Apart from plenty more cleanups, another more fundamental issue to
> > address is how to stop unused caphash entries from piling up in
> > memory. ?Put a timeout on them? ?Let privileged userspace list and
> > occasionally delete them? ?Associate a target task with each entry,
> > where either the task or its decendent can use the capability, but
> > if the task dies we free the caphash entry?
> 
> So, there are a couple of options here (I favor the second approach):
> 1. We can add a timer to expire the capabilities.
> 2. Add a creation time stamp to every capability. Whenever a
> capability is used (i.e. written to /dev/caphash) we can go through
> the list in the kernel and reap the ones whose time stamp has expired.
> We can optimize the data structure later to make this faster.

Ok, I'll do that when I get a chance, do some more testing, and send
out in the next two weeks.

thanks,
-serge
