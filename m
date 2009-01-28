Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZA1N2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZA1N2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZA1N2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:28:33 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53278 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbZA1N2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:28:32 -0500
Date: Thu, 29 Jan 2009 00:28:29 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bron Gondwana <brong@fastmail.fm>, Ray Lee <ray-lk@madrabbit.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
Message-ID: <20090128132829.GA9326@brong.net>
References: <20090128033824.GA1662@brong.net> <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm> <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com> <2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com> <20090128101641.33978100@lxorguk.ukuu.org.uk> <20090128105902.GB29864@brong.net> <20090128113640.2ea5a9fb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128113640.2ea5a9fb@lxorguk.ukuu.org.uk>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 11:36:40AM +0000, Alan Cox wrote:
> > > "A kernel upgrade in a -stable series point release fixed a security DoS"
> > 
> > Alan, that's a complete load of bollocks.  It broke common configurations 
> > of java, postfix and apache on real-world machines, causing significant
> > actual denials of service in previously reliable configurations.
> 
> It fixed a security DoS. I was merely pointing out that the description
> provided before was bogus, incomplete and loaded.

Not allowing user logins would have fixed that particular security DoS
too.  There's a range of pretty destructive things that can "fix" one 
issue at the expense of creating others.

This particular choice of fix just happens to have caused at least three
reported (though not to LKML, but I'll post the URLs for the other two
again in a sec) commonly used applications issues.  These applications
were using the published API in a way which used to work perfectly
well, and not DoSing the system.

How would you define a regression otherwise?  A public and commonly used
API had a new user-space visable error code added that it had never
returned before, and a low enough limit set that this error was seen in
practice by multiple sites.

http://marc.info/?l=fedora-devel-list&m=123134150926934&w=2

http://pero.blogs.aprilmayjune.org/2009/01/22/hadoop-and-linux-kernel-2627-epoll-limits/

> > viable within the code.  The DoS works by creating epoll descriptors
> > watching other epoll descriptors, which strikes me as a much less
> > real-world actual use pattern than a bunch of separate daemons with an
> > epoll watcher each.
> 
> Deliberate attackers don't have to follow typical usage patterns.

Sure, but if typical usage patterns hit your sensor, then you have false
positives.  Adding a DoS sensor that gets false positives is a regression, 
and whitewashing it as "fixed a security DoS" is bogus.  It did that, but
also more than that, and the more was/is sucky.

> > If it's possible to count watches only if they're added to another epoll
> > instance, then we'd have a metric that still catches the N^2 attack, but
> > doesn't interact with the common non-attacky use-case.
> 
> Agreed entirely.

Yeah, enough arguing hey.  Let's come up with a real fix that doesn't
give sites the ugly choice between remaining vulnerable to a known DoS
attack or hobbling common programs that aren't actually using that many
resources.

Bron.
