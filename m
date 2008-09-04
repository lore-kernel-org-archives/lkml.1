Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYIDSEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYIDSEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYIDSEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:04:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56866 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYIDSEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:04:12 -0400
To: serge@hallyn.com
CC: miklos@szeredi.hu, serue@us.ibm.com, ebiederm@xmission.com,
       akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080904174851.GA13693@hallyn.com> (serge@hallyn.com)
Subject: Re: unprivileged mounts git tree
References: <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu> <20080903220215.GA27705@us.ibm.com> <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu> <20080903224334.GA726@us.ibm.com> <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com> <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu> <20080904161729.GA26579@us.ibm.com> <E1KbIqL-0003QO-34@pomaz-ex.szeredi.hu> <20080904174851.GA13693@hallyn.com>
Message-Id: <E1KbJBO-0003Xz-0G@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Sep 2008 20:03:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Serge E. Hallyn wrote:
> Quoting Miklos Szeredi (miklos@szeredi.hu):
> > On Thu, 4 Sep 2008, Serge E. Hallyn wrote:
> > > but you're still doing
> > > 
> > > 	if (IS_MNT_SHARED(old_nd.path.mnt) && !capable(CAP_SYS_ADMIN))
> > > 		goto out;
> > > 
> > > shouldn't it be something like
> > > 
> > > 	if (IS_MNT_SHARED(old_nd.path.mnt) && (old_nd.path.mnt & MNT_USER))
> > > 		goto out;
> > > 
> > > ?
> > 
> > Why would that be an error?  There's no real security gain to be had
> > from restricting a privileged user, but could cause a lot of
> > annoyance.  If we think this is dangerous, then protection should be
> > built into mount(8) with an option to override.  But not into the
> > kernel, IMO.
> 
> We disagree on that.  But can we agree that the check you added is wrong?

No :)

> There is no reason why a user mount should not be able to do shared
> mounts, is there?

I don't know.  It's something to think about in the future, but not
essential.  We know that without the above check the user can do bad
things: propagate mounts back into the source, and we don't want that.

We could allow binding a shared mount if

  a) the owners of the source and destination match
  b) the destination is made a slave of the source

But the current patchset doesn't allow _any_ changes to propagation
without CAP_SYS_ADMIN, so why should bind be an exception?

And yes, this is something to think about, but I think it's a rather
uncommon corner case, and so the patchset very much makes sense
without having to deal with unprivileged mount propagation changes.

>  So should the check above just go away then?

No, we'd be back with the original problem.

Thanks,
Miklos
