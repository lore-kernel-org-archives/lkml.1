Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbXBKMOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbXBKMOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 07:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbXBKMOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 07:14:03 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:52549 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbXBKMOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 07:14:01 -0500
To: rsc@swtch.com
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <ee9e417a0702100457s6ed2c6a3sd5cc45a21db69876@mail.gmail.com>
	(rsc@swtch.com)
Subject: Re: [PATCH] fix quadratic behavior of shrink_dcache_parent()
References: <E1HFdnm-0006DB-00@dorka.pomaz.szeredi.hu>
	 <20070209160055.bbd20c9f.akpm@linux-foundation.org>
	 <ee9e417a0702091623t1ccf55b8wb05b64b9c51474a6@mail.gmail.com>
	 <E1HFnsK-0007Ep-00@dorka.pomaz.szeredi.hu> <ee9e417a0702100457s6ed2c6a3sd5cc45a21db69876@mail.gmail.com>
Message-Id: <E1HGDa7-0000to-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 11 Feb 2007 13:13:23 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Unfortunately this patch doesn't completely solve this problem, since
> > the system will still be hosed due to all memory being used up by
> > dentries.  And I bet the OOM killer won't find the real target (du)
> > but will kill anything before that.
> >
> > So the second part of the problem is to somehow limit the number of
> > dentries used.  Not easy...
> 
> At least with this patch (if I am reading it correctly), once the offending
> culprit is identified and the programs are killed off, everything will go
> back to normal without a reboot.

Yes, it's basically a "normal" OOM situation.  What makes it worse
than usual, is that it's _kernel_ memory being used up which is not
attributed to any process.

So from the OOM killer's point of view it looks like none of the
userspace programs are responsible for the OOM, and it will just
select targets randomly.

By the time it has come to the actual culprits (the filesystem daemon
and 'du') it will have killed almost everything useful.

So it's definitely better than without the patch, but still has room
for improvement.

Thanks,
Miklos
