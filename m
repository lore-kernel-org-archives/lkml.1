Return-Path: <linux-kernel-owner+w=401wt.eu-S964935AbXDMUHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935AbXDMUHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964873AbXDMUHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:07:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964865AbXDMUHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:07:39 -0400
Date: Fri, 13 Apr 2007 22:07:20 +0200
From: Karel Zak <kzak@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linuxram@us.ibm.com, serue@us.ibm.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] unprivileged mount syscall
Message-ID: <20070413200720.GS31445@petra.dvoda.cz>
References: <20070406160238.f3178189.akpm@linux-foundation.org> <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu> <20070409143802.GB4891@sergelap.austin.ibm.com> <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu> <20070409170743.GF24415@sergelap.austin.ibm.com> <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu> <1176194285.2903.67.camel@ram.us.ibm.com> <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu> <1176316116.2811.39.camel@ram.us.ibm.com> <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 01:58:59PM +0200, Miklos Szeredi wrote:
> > On Wed, 2007-04-11 at 12:44 +0200, Miklos Szeredi wrote:
> > > > 1. clone the master namespace.
> > > > 
> > > > 2. in the new namespace
> > > > 
> > > > 	move the tree under /share/$me to /
> > > >         for each ($user, $what, $how) {
> > > >             move /share/$user/$what to /$what
> > > > 	    if ($how == slave) {
> > > >                  make the mount tree under /$what as slave
> > > >             }
> > > >         }
> > > >         
> > > > 3. in the new namespace make the tree under 
> > > >        /share as private and unmount /share
> > > 
> > > Thanks.  I get the basic idea now: the namespace itself need not be
> > > shared between the sessions, it is enough if "share" propagation is
> > > set up between the different namespaces of a user.
> > > 
> > > I don't yet see either in your or Viro's description how the trees
> > > under /share/$USER are initialized.  I guess they are recursively
> > > bound from /, and are made slaves.
> > 
> > yes. I suppose, when a userid is created one of the steps would be
> > 
> > mount --rbind / /share/$USER
> > mount --make-rslave /share/$USER
> > mount --make-rshared /share/$USER
> 
> Thinking a bit more about this, I'm quite sure most users wouldn't
> even want private namespaces.  It would be enough to
> 
>   chroot /share/$USER
> 
> and be done with it.

 I don't think so. How to you want to implement non-shared /tmp
 directories? The chroot is overkill in this case. See:

 http://www.coker.com.au/selinux/talks/sage-2006/PolyInstantiatedDirectories.html
 http://danwalsh.livejournal.com/

> Private namespaces are only good for keeping a bunch of mounts
> referenced by a group of processes.  But my guess is, that the natural
> behavior for users is to see a persistent set of mounts.
> 
> If for example they mount something on a remote machine, then log out
> from the ssh session and later log back in, they would want to see
> their previous mount still there.

 They can mount to /mnt where the directory is shared ("mount
 --make-shared /mnt") and visible and all namespaces.

 I think /share/$USER is an extreme example. You can found more
 situations when private namespaces are nice solution.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
