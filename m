Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbXBJIrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbXBJIrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 03:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXBJIrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 03:47:08 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:45050 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbXBJIrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 03:47:07 -0500
To: rsc@swtch.com
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <ee9e417a0702091623t1ccf55b8wb05b64b9c51474a6@mail.gmail.com>
	(rsc@swtch.com)
Subject: Re: [PATCH] fix quadratic behavior of shrink_dcache_parent()
References: <E1HFdnm-0006DB-00@dorka.pomaz.szeredi.hu>
	 <20070209160055.bbd20c9f.akpm@linux-foundation.org> <ee9e417a0702091623t1ccf55b8wb05b64b9c51474a6@mail.gmail.com>
Message-Id: <E1HFnsK-0007Ep-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 10 Feb 2007 09:46:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > "The file system mounted on /tmp/z in the example contains 2^50
> > directories".   heh.
> >
> > I do wonder how realistic this problem is in real life.
> 
> That's a fair concern, although I was trying this as part
> of evaluating how much someone could hose a system
> if we let them mount arbitrary FUSE servers.  And the
> answer is: they could make it completely unusable,
> requiring reboot.
> 
> I ran a later test that printed how deep it got into
> the file tree and it was only a few hundred thousand
> if I recall correctly.  A determined attacker might even
> manage to do this in a normal file system.

Unfortunately this patch doesn't completely solve this problem, since
the system will still be hosed due to all memory being used up by
dentries.  And I bet the OOM killer won't find the real target (du)
but will kill anything before that.

So the second part of the problem is to somehow limit the number of
dentries used.  Not easy...

Miklos
