Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbXDZWE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbXDZWE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXDZWEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:04:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52028 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124AbXDZWEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:04:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Back to the future.
Date: Fri, 27 Apr 2007 00:08:18 +0200
User-Agent: KMail/1.9.5
Cc: Xavier Bestel <xavier.bestel@free.fr>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org> <1177618081.4737.42.camel@nigel.suspend2.net>
In-Reply-To: <1177618081.4737.42.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704270008.19017.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 April 2007 22:08, Nigel Cunningham wrote:
[--snip--]
> > And no, I'm not saying that my suggestion is the only way to do it. Go 
> > wild. But the *current* situation is just broken. Three different things, 
> > none of which people can agree on. I'd *much* rather see a conceptually 
> > simpler approach that then required, but even more important is that right 
> > now people aren't even discussing alternatives, they're just pushing one 
> > of the three existing things, and that's simply not viable. Because I'm 
> > not merging another one.
> > 
> > In fact, I personally feel that I shouldn't even have merged 
> > userspace-swsusp, but if Andrew thinks it needs to be merged, my personal 
> > feelings simply don't matter that much. I have to trust people. But yes, 
> > as far as *I* am personally concerned, I think it was a mistake to merge 
> > it.
> 
> Perhaps you should try to make an alternative yourself instead of
> pushing us into making something we don't believe will work (my case) or
> have already done but in a way you don't like (Rafael). Don't talk about
> Pavel cutting code. He's just acking/nacking what Rafael sends him.

Well, I think that much of what Linus is saying indicates that he hasn't tried
to write any such thing himself. ;-)

Anyway, I'm tired of all this thing.  Really.  I've just been trying to make
things _work_ more-or-less reliably in a way that Pavel liked and I really
didn't know that much about the kernel when I started.  In fact, I started as a
user who needed certain functionality from the kernel and that was not there
at the time.  I've made some mistakes because of that (like the definitions of
the ioctl numbers in suspend.h - this was just a rookie mistake, and I'm
ashamed of it, but _nobody_ catched it, although I believe many people were
looking at the patch).

Now that I know much more than before, I can say I agree with Linus on his
opinion about the separation of s2ram form the snapshot/restore functionality
(I'll call it 'hibernation' for simplicity from now on).  It should be done,
because it would make things simpler and cleaner.  Still, it will be difficult
to do without screwing users en masse and that's my main concern here.

I don't agree that we don't need the tasks freezer for suspending and
hibernation.  We need it, because we need to be sure that the (other) tasks
will not get us in the way, and that also applies to kernel threads (and I
don't think the tasks freezer is 'screwing' them, BTW).

I agree that the userland interface for swsusp is not very nice and I'm going
to do my best to clean that up.  I hope that someone will help me, but if not,
then that's fine.  OTOH, it's difficult, if not impossible, to do a
userland-driven hibernation in a completely clean way.  I've tried that and I'm
not exactly satisfied with the result, although it works and some distros use
it.  I wouldn't have done it again, but then I'm going to support the existing
users, as I promised.

Now, I think that the hibernation should better be done completely in the
kernel, because that's just conceptually simpler, although some data exchange
with the user land may be acceptable for some optional fancy stuff.  I'm also
tierd of the endless "to merge or not to merge suspend2" discussions that just
lead to nowhere.  For these reasons I declare that I'm ready to cooperate with
Nigel on integrating as much of suspend2 as reasonably possible into the
existing infrastructure, under the following conditions:
- we don't remove the existing user-visible interfaces
- we work on one piece of code at a time
- we avoid code duplication, as much as possible
- we avoid using open-coded things, if possible
- if we don't agree on something, we ask someone wiser (volunteers welcome ;-))

If that's acceptable, we can start tomorrow.  In the process, we can try to
separate the hibernation code paths from the s2ram ones, but that will require
a lot of knowledge about things that neither me nor Nigel, AFAICT, are very
familiar with, like writing device drivers.

Greetings,
Rafael
