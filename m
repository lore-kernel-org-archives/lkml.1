Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZA1D6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZA1D6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZA1D5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:57:49 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44398 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbZA1D5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:57:48 -0500
Date: Wed, 28 Jan 2009 14:57:46 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Bron Gondwana <brong@fastmail.fm>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090128035746.GA3351@brong.net>
References: <1232686261.9977.1296303473@webmail.messagingengine.com> <20090123051620.GA8122@suse.de> <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de> <20090128033824.GA1662@brong.net> <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 07:46:18PM -0800, Davide Libenzi wrote:
> On Wed, 28 Jan 2009, Bron Gondwana wrote:
> 
> > On Tue, Jan 27, 2009 at 04:35:19PM -0800, Greg KH wrote:
> > > Can you resubmit all 4 patches, and cc: the epoll author, Davide?  He's
> > > the one that needs to accept these changes.
> > 
> > It's three now (two of them deserved to merged) and re-ordered so the
> > first two are trivial and the complex bits are easily skipped if you
> > don't want them.  
> > 
> > Just looking for Davide's email address.  Found it :)  I'll follow up
> > this message with the patches.  I'm not going to CC everyone else again
> > - but I'll CC LKML so you can follow it there if you want.
> 
> I already gave you my opinion on such code. There is no need for it. If 
> your servers are loaded, in the same way you bump NFILES (and likely 
> even other default configs), you bump up max_user_instances:
 
How can you tell if it's heavily loaded if you can't tell what the
current usage is?  Just wait until you hit the limit?

> $ echo NN > /proc/sys/fs/epoll/max_user_instances
>
> It requires no extra crud in the kernel, and it works pretty darn good.

The current default of 128 is breaking pretty much every decent sized
postfix or apache server out there, where in the past there is no limit.
That's an awful lot of sysadmin time to track down why your server is
suddently hitting limits that didn't used to exist across every
installed Linux machine out there.

Of course the distributions can put an override in their sysctl.conf,
but in that case why not have a higher default?

Bron ( besides, the first two patches certainly aren't cruft, they're
       just different default behaviours.  The third is cruft, but I
       believe it's useful cruft in the same way file-nr is cruft )
