Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZA1K7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZA1K7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZA1K7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:59:07 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42201 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947AbZA1K7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:59:04 -0500
Date: Wed, 28 Jan 2009 21:59:02 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ray Lee <ray-lk@madrabbit.org>, Davide Libenzi <davidel@xmailserver.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
Message-ID: <20090128105902.GB29864@brong.net>
References: <20090128033824.GA1662@brong.net> <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm> <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com> <2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com> <20090128101641.33978100@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128101641.33978100@lxorguk.ukuu.org.uk>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 10:16:41AM +0000, Alan Cox wrote:
> > It's really simple. A kernel upgrade in a -stable series point release
> > broke a rational user-space setup. If you don't want to adjust the
> 
> You can just as equally load the description the other way:

Only if you're ignoring reality.

> "A kernel upgrade in a -stable series point release fixed a security DoS"

Alan, that's a complete load of bollocks.  It broke common configurations 
of java, postfix and apache on real-world machines, causing significant
actual denials of service in previously reliable configurations.

How about "A kernel upgrade in a -stable series replaced one potential
DoS with another DoS and provided a tunable knob to select which DoS you
would prefer, defaulting to the opposite of the previous behaviour"
 
> Which is not to say that a smarter limit isn't needed.

Yeah, I have an idea about that, but I need to see if it's actually
viable within the code.  The DoS works by creating epoll descriptors
watching other epoll descriptors, which strikes me as a much less
real-world actual use pattern than a bunch of separate daemons with an
epoll watcher each.

If it's possible to count watches only if they're added to another epoll
instance, then we'd have a metric that still catches the N^2 attack, but
doesn't interact with the common non-attacky use-case.

I'd be much happier if we could remove the dichotomy of "allow the DoS
or live with a highly crippled epoll implementation until some of the
biggest daemons out there change their usage patterns" (thinking
particularly of java 1.6 and apache here.  Largish postfix installations
are much rarer)

Bron.
