Return-Path: <linux-kernel-owner+w=401wt.eu-S1030772AbXDPPoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030772AbXDPPoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030766AbXDPPoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:44:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38107 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030758AbXDPPoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:44:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linuxram@us.ibm.com, containers@lists.osdl.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
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
	<E1HdNUv-0006gt-00@dorka.pomaz.szeredi.hu>
Date: Mon, 16 Apr 2007 09:40:35 -0600
In-Reply-To: <E1HdNUv-0006gt-00@dorka.pomaz.szeredi.hu> (Miklos Szeredi's
	message of "Mon, 16 Apr 2007 11:27:45 +0200")
Message-ID: <m1d524l43w.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

>> Arn't there ways to escape chroot jails? Serge had pointed me to a URL
>> which showed chroots can be escaped. And if that is true than having all
>> user's private mount tree in the same namespace can be a security issue?
>
> No.  In fact chrooting the user into /share/$USER will actually
> _grant_ a privilege to the user, instead of taking it away.  It allows
> the user to modify it's root namespace, which it wouldn't be able to
> in the initial namespace.
>
> So even if the user could escape from the chroot (which I doubt), s/he
> would not be able to do any harm, since unprivileged mounting would be
> restricted to /share.  Also /share/$USER should only have read/search
> permission for $USER or no permissions at all, which would mean, that
> other users' namespaces would be safe from tampering as well.

A couple of points.
- chroot can be escaped, it is just a chdir for the root directory it
  is not a security feature.  The only security is that you have to be root to call chdir.
  A carefully done namespace setup won't have that issue.

- While it may not violate security as far as what a user is allowed to modify it may
  violate security as far as what a user is allowed to see.

There are interesting per login cases as well such as allowing a user to replicate
their mount tree from another machine when they log in.  When /home is on a network
filesystem this can be very practical and can allow propagation of mounts across
machines not just across a single login session.

Eric




