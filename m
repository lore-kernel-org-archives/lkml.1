Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbXEPV6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbXEPV6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760649AbXEPV6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:58:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15722 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbXEPV6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:58:14 -0400
Date: Wed, 16 May 2007 15:00:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
Message-Id: <20070516150036.aaa2ce95.randy.dunlap@oracle.com>
In-Reply-To: <20070516210922.GA24231@localdomain>
References: <20070513132517.GA14038@localdomain>
	<20070513092352.18cd80de@freepuppy>
	<20070513182035.GA10207@infradead.org>
	<20070515082311.GA6816@ucw.cz>
	<20070516165107.GA13190@localdomain>
	<20070516193321.GA5156@ucw.cz>
	<20070516210922.GA24231@localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 00:09:22 +0300 Dan Aloni wrote:

> On Wed, May 16, 2007 at 07:33:21PM +0000, Pavel Machek wrote:
> > On Wed 2007-05-16 19:51:07, Dan Aloni wrote:
> > > On Tue, May 15, 2007 at 08:23:11AM +0000, Pavel Machek wrote:
> > > > On Sun 2007-05-13 19:20:35, Christoph Hellwig wrote:
> > > > > On Sun, May 13, 2007 at 09:23:52AM -0700, Stephen Hemminger wrote:
> > > > > > On Sun, 13 May 2007 16:25:17 +0300
> > > > > > Dan Aloni <da-x@monatomic.org> wrote:
> > > > > > 
> > > > > > > Kernel developers might find it useful for quickly getting out from some 
> > > > > > > rough debugging scenarios.
> > > > > > > 
> > > > > > > Signed-off-by: Dan Aloni <da-x@monatomic.org>
> > > > > > > 
> > > > > > 
> > > > > > There is already the modprobe blacklist ability in user space.
> > > > > 
> > > > > doesn't really help if hotplug loads a broken module before you're getting
> > > > > a login prompt.  So while this is a bit of a hack I'm all in favour of this.
> > > > > (Especially as I got hit by this issue again yesterday)
> > > > 
> > > > It is quite a bick hack. Unknown kernel parameters are passed to init,
> > > > can we just make modprobe parse that?
> > > 
> > > We can, and then we also have to patch busybox's own fork of modprobe
> > > and every other code out there that does the same thing (not so much, 
> > > but still).
> > 
> > Too lazy to fix userspace so lets break kernel?
> > 
> > No, thanks.
> 
> I wouldn't consider it breaking, more like extending. But regardless 
> of userspace, in the future we can also use this same interface in 
> order to disable _built-in_ kernel modules and functionlity (e.g.
> 'nousb' could turn into something more canonical). This can be useful 
> for people working in the embedded who compile module-less kernels (if 
> module-less kernels are considered bad practicle these days, I'd like
> to know more).
> 
> Just a thought..
> 
> One can even come up with a kernel parameter that allows a developer 
> to skip a call to one or more of the initcall functions based on 
> its name only even with !CONFIG_KALLSYMS (looks like that except 
> for crypto/, almost all initcalls have unique names these days).

sounds good to me.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
