Return-Path: <linux-kernel-owner+w=401wt.eu-S1030782AbXDPP5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030782AbXDPP5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030787AbXDPP5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:57:17 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:32940 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030782AbXDPP5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:57:16 -0400
To: ebiederm@xmission.com
CC: linuxram@us.ibm.com, containers@lists.osdl.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <m1d524l43w.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070406160238.f3178189.akpm@linux-foundation.org>
	<E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu>
	<20070409143802.GB4891@sergelap.austin.ibm.com>
	<E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu>
	<20070409170743.GF24415@sergelap.austin.ibm.com>
	<E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu>
	<1176194285.2903.67.camel@ram.us.ibm.com>
	<E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu>
	<1176316116.2811.39.camel@ram.us.ibm.com>
	<E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu>
	<20070413132832.GA1483@sergelap.austin.ibm.com>
	<E1HcMOq-0002As-00@dorka.pomaz.szeredi.hu>
	<1176711509.9488.4.camel@ram.us.ibm.com>
	<E1HdNUv-0006gt-00@dorka.pomaz.szeredi.hu> <m1d524l43w.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HdTYJ-0007al-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 16 Apr 2007 17:55:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Arn't there ways to escape chroot jails? Serge had pointed me to a URL
> >> which showed chroots can be escaped. And if that is true than having all
> >> user's private mount tree in the same namespace can be a security issue?
> >
> > No.  In fact chrooting the user into /share/$USER will actually
> > _grant_ a privilege to the user, instead of taking it away.  It allows
> > the user to modify it's root namespace, which it wouldn't be able to
> > in the initial namespace.
> >
> > So even if the user could escape from the chroot (which I doubt), s/he
> > would not be able to do any harm, since unprivileged mounting would be
> > restricted to /share.  Also /share/$USER should only have read/search
> > permission for $USER or no permissions at all, which would mean, that
> > other users' namespaces would be safe from tampering as well.
> 
> A couple of points.
> - chroot can be escaped, it is just a chdir for the root directory
> it is not a security feature.  The only security is that you have to
> be root to call chdir.  A carefully done namespace setup won't have
> that issue.
> 
> - While it may not violate security as far as what a user is allowed
> to modify it may violate security as far as what a user is allowed
> to see.

I think that's just up to the permissions in the global namespace.  In
this example if you 'chmod 0 /share' there won't be anything for the
user to see.

> There are interesting per login cases as well such as allowing a
> user to replicate their mount tree from another machine when they
> log in.  When /home is on a network filesystem this can be very
> practical and can allow propagation of mounts across machines not
> just across a single login session.

Yeah, sounds interesting, but I think it's better to get the basics
working first, and then we can start to think about the extras.

Btw, there's nothing that prevents cloning the namespace _after_
chrooting into the per-user tree.  That would still be simpler than
doing it the other way round: first creating per-session namespaces
and then setting up mount propagation between them.

Miklos
