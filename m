Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbZCTCoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbZCTCoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 22:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZCTCnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 22:43:55 -0400
Received: from kroah.org ([198.145.64.141]:50851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750831AbZCTCny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 22:43:54 -0400
Date: Thu, 19 Mar 2009 19:42:49 -0700
From: Greg KH <greg@kroah.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs
Message-ID: <20090320024249.GA19989@kroah.com>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp> <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp> <20090320004539.GF18781@kroah.com> <3934.1237515949@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3934.1237515949@jrobl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 11:25:49AM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Greg KH:
> > > +Description:
> > > +		It shows the consumed blocks by xib (External Inode Number
> > > +		Bitmap), its block size and file size.
> > > +		When the aufs mount option 'noxino' is specified, it
> > > +		will be empty. About XINO files, see
> > > +		Documentation/filesystems/aufs/aufs.5 in detail.
> > 
> > Sysfs files are one value per file.  This violates that rule.
> 
> Current print format is 
> 	"%llux%lu %lld\n", st->blocks, st->blksize, (long long)st->size
> 
> Do you mean this has three values and violates the rule?

Hm, rule is "one value per file", since this file has 3 values, what do
you think?  :)

> And aufs should create three entries such like xib/blocks, xib/blksize
> and xib/size?

Yes.

> If I change it "<blocks>x<blksize>", is it still violation?

I don't understand.

> > Are all of these things something that a "normal" user would care about?
> > or are they development / debugging things?
> 
> Normal users want to care them, I guess.

Really?  Try leaving them out for now and see if anyone notices :)

> > And why are you using seq_file for a sysfs file?  That's not allowed,
> > and a sure sign you are doing something wrong, please remove all of
> > that.
> 
> I just wanted to set limit its size to PAGE_SIZE to print the absolute
> path. Is there another better approach?

Do you really need to print these paths?  And are they going to bigger
than PATH_MAX?

thanks,

greg k-h
