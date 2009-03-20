Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZCTC0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZCTC0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 22:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZCTCZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 22:25:53 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:61600 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbZCTCZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 22:25:53 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs 
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090320004539.GF18781@kroah.com>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp> <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp> <20090320004539.GF18781@kroah.com>
Date: Fri, 20 Mar 2009 11:25:49 +0900
Message-ID: <3934.1237515949@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg KH:
> > +Description:
> > +		It shows the consumed blocks by xib (External Inode Number
> > +		Bitmap), its block size and file size.
> > +		When the aufs mount option 'noxino' is specified, it
> > +		will be empty. About XINO files, see
> > +		Documentation/filesystems/aufs/aufs.5 in detail.
> 
> Sysfs files are one value per file.  This violates that rule.

Current print format is 
	"%llux%lu %lld\n", st->blocks, st->blksize, (long long)st->size

Do you mean this has three values and violates the rule?
And aufs should create three entries such like xib/blocks, xib/blksize
and xib/size?
If I change it "<blocks>x<blksize>", is it still violation?


> Are all of these things something that a "normal" user would care about?
> or are they development / debugging things?

Normal users want to care them, I guess.
Since XINO files grow only, some heavy users had met ENOSPC
actually. Currently aufs supports automatic truncation for XINO files in
tmpfs only.


> And why are you using seq_file for a sysfs file?  That's not allowed,
> and a sure sign you are doing something wrong, please remove all of
> that.

I just wanted to set limit its size to PAGE_SIZE to print the absolute
path. Is there another better approach?


Thank you for reviewing
J. R. Okajima
