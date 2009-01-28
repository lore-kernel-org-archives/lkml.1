Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZA1FsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZA1FsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 00:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZA1FsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 00:48:10 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:53060 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZA1FsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 00:48:09 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Jan 2009 21:48:07 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Willy Tarreau <w@1wt.eu>
cc: Greg KH <gregkh@suse.de>, Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
In-Reply-To: <20090128053642.GL5038@1wt.eu>
Message-ID: <alpine.DEB.1.10.0901272142530.20262@alien.or.mcafeemobile.com>
References: <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de> <20090128033824.GA1662@brong.net> <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com>
 <20090128035746.GA3351@brong.net> <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com> <20090128052630.GA9512@suse.de> <20090128053642.GL5038@1wt.eu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Willy Tarreau wrote:

> On Tue, Jan 27, 2009 at 09:26:30PM -0800, Greg KH wrote:
> > On Tue, Jan 27, 2009 at 08:10:41PM -0800, Davide Libenzi wrote:
> > > In my servers, I know if they are going to be loaded, and I bump NFILES 
> > > (and a few other things) to the correct place. Since many of those 
> > > limits do not actually pre-allocate any resource, I don't need to wait and 
> > > monitor the values, before taking proper action.
> > 
> > But what about people who want to know what the current usages are, so
> > that they _can_ monitor things and adjust them on the fly if things are
> > about to go boom?
> > 
> > I see no reason why we can't leave the value where it is today, and add
> > the ability to both turn the limits off entirely, and also report our
> > current usage.  That keeps the DOS from happening on "default" systems,
> > and lets admins have an idea if they need to bump up the values on their
> > systems as well.
> > 
> > I don't understand your objection to allowing the usage to be monitored.
> 
> Agreed. If sysadmins get trapped by the upgrade, the fix for an
> hypotethical DoS is a 100%-certain DoS by itself. The general sense
> that "if it's not broken, don't fix it" applies here as well. The
> server's sysadmin should not be bothered by a security upgrade (anyway,
> after a few minutes of havoc in prod, he will revert to previous version
> without trying to understand any further). But the campus sysadmin having
> trouble with local users already spends a lot of time tweaking limits.
> Now we offer them a new limit they can tune, they'll happily use it.
> Anyway, even at 128 they'll probably lower it down a lot. So basically
> we're with a medium value which does not fit any usage.

You know, it's not me that decides what goes of certain trees or not ;) 
I've been pinged about the problem, and a patch was sent with values that 
seemed appropriate for typical epoll usages. Epoll is a multiplexing 
interface, so the thought was that not too many instances were lingering 
around. Probably the default max_instances should have been made lomem 
dependent like max_user_watches in the first place, leading to higher 
max_instances values, with respect of the potential DoS.



- Davide


