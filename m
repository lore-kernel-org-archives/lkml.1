Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbYEEN35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbYEEN35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYEEN3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:29:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52649 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYEEN3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:29:45 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, menage@google.com
In-reply-to: <20080505130804.GA1809@infradead.org> (message from Christoph
	Hellwig on Mon, 5 May 2008 09:08:04 -0400)
Subject: Re: [patch 03/15] cgroup: dont call vfs_mkdir
References: <20080505095440.820370974@szeredi.hu> <20080505095511.217634550@szeredi.hu> <20080505110016.GC20910@infradead.org> <E1Jszri-0005uq-4x@pomaz-ex.szeredi.hu> <20080505130804.GA1809@infradead.org>
Message-Id: <E1Jt0l8-00066L-NC@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 15:29:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Looks correct but I don't think it's a good idea.  Spreading more logic
> > > into filesystems without a good reason is rarely a good idea.
> > 
> > (Thanks for the review, Christoph)
> > 
> > Agreed completely, but vfs_* aren't for filesystems to call, rather
> > for entities calling _into_ filesystems from the outside.  This is
> > actually a very rare thing, so adding some extra logic for the sake of
> > cleanliness should be OK.
> > 
> > Now it can be argued, that cgroup_clone() is calling into the
> > filesystem from the outside.  But it's not really doing that, rather
> > it's making an internal modification to a specific filesystem,
> > triggered by some external action.
> 
> I don't think that matters. We're not about overly strict layering, and
> especialy this kind where you call into a higher layer to get back into
> the lower one is not harmful at all.  For cgroup it's only a small
> duplication, but e.g. I don't really like all the duplications in the
> reiserfs case.

I think there's some good reasons, other than just to get rid of the
vfs recursion.  I took this change from Jeff Mahoney's patchset.

>  Unless we have a very good reason why the useage of the
> vfs_ function should go away from the filesystem code I don't think
> we want this.

We do have a good reason: r/o bind mounts and AppArmor.  And please
don't tell me, you also think that moving the security hooks to
callers is a good idea ;)  That would actually be a change with a much
larger impact, both in terms of code duplication and of verifying
correctness.

Miklos
