Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbXDPICa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbXDPICa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964959AbXDPICa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:02:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36826 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932AbXDPICY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:02:24 -0400
Subject: Re: [patch 0/8] unprivileged mount syscall
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu>
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu>
	 <20070409143802.GB4891@sergelap.austin.ibm.com>
	 <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu>
	 <20070409170743.GF24415@sergelap.austin.ibm.com>
	 <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu>
	 <1176194285.2903.67.camel@ram.us.ibm.com>
	 <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu>
	 <1176316116.2811.39.camel@ram.us.ibm.com>
	 <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 00:59:06 -0700
Message-Id: <1176710347.2954.8.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-13 at 13:58 +0200, Miklos Szeredi wrote:
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
> 
> Private namespaces are only good for keeping a bunch of mounts
> referenced by a group of processes.  But my guess is, that the natural
> behavior for users is to see a persistent set of mounts.
> 
> If for example they mount something on a remote machine, then log out
> from the ssh session and later log back in, they would want to see
> their previous mount still there.

They will continue see their previous mount tree. 
Even if all the namespaces belonging to the different sessions of the
user get dismantled when all the sessions exit, the a mirror of those 
mount trees continue to exist under /share/$USER in the original
namespace.  So I don't think we have a issue.

NOTE: when I say 'original namespace' I mean the admin namespace; the
first namespace that gets created when the machine boots.

RP


> 
> Miklos

