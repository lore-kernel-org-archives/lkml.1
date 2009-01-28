Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbZA1EKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbZA1EKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZA1EKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:10:45 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:51390 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZA1EKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:10:44 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Jan 2009 20:10:41 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Bron Gondwana <brong@fastmail.fm>
cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
In-Reply-To: <20090128035746.GA3351@brong.net>
Message-ID: <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com>
References: <1232686261.9977.1296303473@webmail.messagingengine.com> <20090123051620.GA8122@suse.de> <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net>
 <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de> <20090128033824.GA1662@brong.net> <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com> <20090128035746.GA3351@brong.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Bron Gondwana wrote:

> On Tue, Jan 27, 2009 at 07:46:18PM -0800, Davide Libenzi wrote:
> > On Wed, 28 Jan 2009, Bron Gondwana wrote:
> > 
> > > On Tue, Jan 27, 2009 at 04:35:19PM -0800, Greg KH wrote:
> > > > Can you resubmit all 4 patches, and cc: the epoll author, Davide?  He's
> > > > the one that needs to accept these changes.
> > > 
> > > It's three now (two of them deserved to merged) and re-ordered so the
> > > first two are trivial and the complex bits are easily skipped if you
> > > don't want them.  
> > > 
> > > Just looking for Davide's email address.  Found it :)  I'll follow up
> > > this message with the patches.  I'm not going to CC everyone else again
> > > - but I'll CC LKML so you can follow it there if you want.
> > 
> > I already gave you my opinion on such code. There is no need for it. If 
> > your servers are loaded, in the same way you bump NFILES (and likely 
> > even other default configs), you bump up max_user_instances:
>  
> How can you tell if it's heavily loaded if you can't tell what the
> current usage is?  Just wait until you hit the limit?

In my servers, I know if they are going to be loaded, and I bump NFILES 
(and a few other things) to the correct place. Since many of those 
limits do not actually pre-allocate any resource, I don't need to wait and 
monitor the values, before taking proper action.
Sorry, the whole patch set is a big NACK for many reasons.
We'd have happily avoided those limits altogether, but 100-160MB of kernel 
memory able to be pinned by unprivileged users is easily a DoS on multiuser
systems.



- Davide


