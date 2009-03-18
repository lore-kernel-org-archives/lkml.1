Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZCRRP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZCRRP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZCRRPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:15:49 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41363 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbZCRRPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=UIVG1Ku6fDq6lv/aWnWI+INS1F6Jxf/F9FaFMgpzCp+2T1LN5j1wH0BsdrNqcg43YI
         5U7RYxp7vf8oOa27QOAV7OV6cagp7ag17tzI6nIV1vZsm8AmquqR2xdFse3enf2TtQ1V
         UGc2OCHmqWSEFjY/gfo8oaT0UUNqtJds89CPA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PATCH] block: cleanup patches, take#2
Date: Wed, 18 Mar 2009 18:17:11 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc8-next-20090317; KDE/4.2.0; i686; ; )
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
References: <1237170540-19130-1-git-send-email-tj@kernel.org> <200903161853.14268.bzolnier@gmail.com> <49BEEA64.6060607@kernel.org>
In-Reply-To: <49BEEA64.6060607@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903181817.11456.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 March 2009, Tejun Heo wrote:
> Hello, Bartlomiej.
> 
> Bartlomiej Zolnierkiewicz wrote:
> > Patches look fine but 0002-0003 will cause pata/block merge conflicts
> > for linux-next once they go into block tree so no ACK from me for this
> > approach.
> > 
> > $ patch -p1 --dry-run < 0002.patch
> > patching file drivers/ide/ide-disk.c
> > Hunk #1 FAILED at 405.
> > 1 out of 1 hunk FAILED -- saving rejects to file drivers/ide/ide-disk.c.rej
> > patching file drivers/ide/ide-ioctls.c
> > 
> > $ patch -p1 --dry-run < 0003.patch
> > patching file drivers/ide/ide-cd.c
> > Reversed (or previously applied) patch detected!  Assume -R? [n]
> 
> Heh... for some reason, I think Stephen wouldn't have much problem
> merging those conflicts.

Well, you can just ask Stephen if he is fine with fixing merge conflicts
for a week or so.  If he agrees fine with me.  I just wouldn't like to see
the _whole_ tree dropped from linux-next because of the last moment block
_cleanup_ patches.

> I was hoping to push this patchset into 2.6.30.  The thing is that if
> you only want to take changes from -linus and don't want to provide
> git trees, your tree is kind of blocked from both sides except around
> -rc1 window, so if there are multiple related changesets, they either
> have to go in one after another during a -rc1 window or they need to
> be split over multiple -rc1 windows, either of which isn't gonna work
> very well.
> 
> Please note that this isn't exactly some overhead which is unduly
> weighed on you.  Mid-layer or inter-related API changes often incur
> merge conflicts and things get very difficult unless there's some
> level of cooperation among related trees.
> 
> I understand that you're constrained time and resource-wise and will
> be happy to make things easier on your side but options are severely
> limited if you don't want to take any changes other than from
> upstream.  It would be best if you can maintain IDE changes in a git
> tree.  All that you lose are petty controls over change history.  The
> tree might look less tidy but it makes things much easier when
> multiple trees are involved.  I'll be happy to provide merge commits

I have been planning on quilt -> git conversion of pata-2.6 tree for some
time now but these merge conflicts happen very seldom (once in 6-12 months)
while the transition period would require quite a lot of time and work...

Anyway point taken.

> between blk and ide at sync points, so that you can pull from them and
> don't have to worry about conflicts.  I don't really think it will add
> a lot to your workload.
> 
> That said, let's postpone this patchset post -rc1 window and see how
> things can be worked out then.  Hmmm... I'll move the IDE patches on
> top of linux-next/pata-2.6 with other IDE patches.

Please do and thanks for understanding.

I think that we can deal with the rest of patches without a problem in the
second week of the merge window so everything will be nicely sorted out by
the time of -rc1.

Thanks.
Bart
