Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXDMMAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXDMMAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXDMMAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:00:16 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:51653 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbXDMMAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:00:14 -0400
To: linuxram@us.ibm.com
CC: serue@us.ibm.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1176316116.2811.39.camel@ram.us.ibm.com> (message from Ram Pai
	on Wed, 11 Apr 2007 11:28:36 -0700)
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu>
	 <20070409143802.GB4891@sergelap.austin.ibm.com>
	 <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu>
	 <20070409170743.GF24415@sergelap.austin.ibm.com>
	 <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu>
	 <1176194285.2903.67.camel@ram.us.ibm.com>
	 <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu> <1176316116.2811.39.camel@ram.us.ibm.com>
Message-Id: <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 13 Apr 2007 13:58:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2007-04-11 at 12:44 +0200, Miklos Szeredi wrote:
> > > 1. clone the master namespace.
> > > 
> > > 2. in the new namespace
> > > 
> > > 	move the tree under /share/$me to /
> > >         for each ($user, $what, $how) {
> > >             move /share/$user/$what to /$what
> > > 	    if ($how == slave) {
> > >                  make the mount tree under /$what as slave
> > >             }
> > >         }
> > >         
> > > 3. in the new namespace make the tree under 
> > >        /share as private and unmount /share
> > 
> > Thanks.  I get the basic idea now: the namespace itself need not be
> > shared between the sessions, it is enough if "share" propagation is
> > set up between the different namespaces of a user.
> > 
> > I don't yet see either in your or Viro's description how the trees
> > under /share/$USER are initialized.  I guess they are recursively
> > bound from /, and are made slaves.
> 
> yes. I suppose, when a userid is created one of the steps would be
> 
> mount --rbind / /share/$USER
> mount --make-rslave /share/$USER
> mount --make-rshared /share/$USER

Thinking a bit more about this, I'm quite sure most users wouldn't
even want private namespaces.  It would be enough to

  chroot /share/$USER

and be done with it.

Private namespaces are only good for keeping a bunch of mounts
referenced by a group of processes.  But my guess is, that the natural
behavior for users is to see a persistent set of mounts.

If for example they mount something on a remote machine, then log out
from the ssh session and later log back in, they would want to see
their previous mount still there.

Miklos
