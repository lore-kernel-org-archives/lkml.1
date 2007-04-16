Return-Path: <linux-kernel-owner+w=401wt.eu-S965085AbXDPIUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085AbXDPIUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965051AbXDPIUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:20:21 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33179 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965042AbXDPIUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:20:19 -0400
Subject: Re: [patch 0/8] unprivileged mount syscall
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1HcMOq-0002As-00@dorka.pomaz.szeredi.hu>
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
Content-Type: text/plain
Date: Mon, 16 Apr 2007 01:18:29 -0700
Message-Id: <1176711509.9488.4.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-13 at 16:05 +0200, Miklos Szeredi wrote:
> > > Thinking a bit more about this, I'm quite sure most users wouldn't
> > > even want private namespaces.  It would be enough to
> > > 
> > >   chroot /share/$USER
> > > 
> > > and be done with it.
> > > 
> > > Private namespaces are only good for keeping a bunch of mounts
> > > referenced by a group of processes.  But my guess is, that the natural
> > > behavior for users is to see a persistent set of mounts.
> > > 
> > > If for example they mount something on a remote machine, then log out
> > > from the ssh session and later log back in, they would want to see
> > > their previous mount still there.
> > > 
> > > Miklos
> > 
> > Agreed on desired behavior, but not on chroot sufficing.  It actually
> > sounds like you want exactly what was outlined in the OLS paper.
> > 
> > Users still need to be in a different mounts namespace from the admin
> > user so long as we consider the deluser and backup problems
> 
> I don't think it matters, because /share/$USER duplicates a part or
> the whole of the user's namespace.
> 
> So backup would have to be taught about /share anyway, and deluser
> operates on /home/$USER and not on /share/*, so there shouldn't be any
> problem.
> 
> There's actually very little difference between rbind+chroot, and
> CLONE_NEWNS.  In a private namespace:
> 
>   1) when no more processes reference the namespace, the tree will be
>     disbanded
> 
>   2) the mount tree won't be accessible from outside the namespace
> 
> Wanting a persistent namespace contradicts 1).
> 
> Wanting a per-user (as opposed to per-session) namespace contradicts
> 2).  The namespace _has_ to be accessible from outside, so that a new
> session can access/copy it.

As i mentioned in the previous mail, disbanding all the namespaces of a
user will not disband his mount tree, because a mirror of the mount tree
still continues to exist in /share/$USER in the admin namespace.

And a new user session can always use this copy to create a namespace
that  looks identical to that which existed earlier.


> 
> So both requirements point to the rbind/chroot solution.

Arn't there ways to escape chroot jails? Serge had pointed me to a URL
which showed chroots can be escaped. And if that is true than having all
user's private mount tree in the same namespace can be a security issue?

RP

> 
> Miklos

