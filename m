Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbXDOUWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbXDOUWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbXDOUWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:22:25 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:49697 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbXDOUWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:22:24 -0400
To: kzak@redhat.com
CC: linuxram@us.ibm.com, serue@us.ibm.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20070413200720.GS31445@petra.dvoda.cz> (message from Karel Zak
	on Fri, 13 Apr 2007 22:07:20 +0200)
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070406160238.f3178189.akpm@linux-foundation.org> <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu> <20070409143802.GB4891@sergelap.austin.ibm.com> <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu> <20070409170743.GF24415@sergelap.austin.ibm.com> <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu> <1176194285.2903.67.camel@ram.us.ibm.com> <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu> <1176316116.2811.39.camel@ram.us.ibm.com> <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu> <20070413200720.GS31445@petra.dvoda.cz>
Message-Id: <E1HdBDd-0005nb-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 15 Apr 2007 22:21:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thinking a bit more about this, I'm quite sure most users wouldn't
> > even want private namespaces.  It would be enough to
> > 
> >   chroot /share/$USER
> > 
> > and be done with it.
> 
>  I don't think so. How to you want to implement non-shared /tmp
>  directories?

  mount --bind /.tmp/$USER /share/$USER/tmp

or whatever else this polyunsaturated thingy does within the cloned
namespace.

> The chroot is overkill in this case.

What do you mean it's an overkill?  clone(CLONE_NS) duplicates all the
mounts, just as mount --rbind does.

> > Private namespaces are only good for keeping a bunch of mounts
> > referenced by a group of processes.  But my guess is, that the natural
> > behavior for users is to see a persistent set of mounts.
> > 
> > If for example they mount something on a remote machine, then log out
> > from the ssh session and later log back in, they would want to see
> > their previous mount still there.
> 
>  They can mount to /mnt where the directory is shared ("mount
>  --make-shared /mnt") and visible and all namespaces.
> 
>  I think /share/$USER is an extreme example. You can found more
>  situations when private namespaces are nice solution.

Private to a single login session?  I'd like to hear examples.

Thanks,
Miklos
