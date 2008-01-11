Return-Path: <linux-kernel-owner+w=401wt.eu-S1762328AbYAKWPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762328AbYAKWPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbYAKWPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:15:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:55577 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbYAKWPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:15:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L7x6BzzkXb+3qS1peoL0AjcwcP30ST0cEuAXa2h2RGtF3dk5mvSPUvusNfK1qq1SMtFUZlWgeIp1tGvcyK4eBxaeap47LRwcc9wa2cWT/Zzd8QUNRHkcYqhMwlov0BrFaZ6BaSIdlDsRbshnfRfq84xM5pPIjgJ4qhCYue8uDao=
Message-ID: <4df4ef0c0801111415r85c602axdd5d4c85e5bf40ed@mail.gmail.com>
Date: Sat, 12 Jan 2008 01:15:45 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Peter Staubach" <staubach@redhat.com>
Subject: Re: [PATCH 2/2][RFC][BUG] msync: updating ctime and mtime at syncing
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       jesper.juhl@gmail.com
In-Reply-To: <4787E6CD.3080709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200006638.19293.42.camel@codedot>
	 <1200012249.20379.2.camel@codedot> <4787BC89.2010106@redhat.com>
	 <4df4ef0c0801111340n515a3c70n4b26468ddb47ebd2@mail.gmail.com>
	 <4787E6CD.3080709@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/12, Peter Staubach <staubach@redhat.com>:
> Anton Salikhmetov wrote:
> > 2008/1/11, Peter Staubach <staubach@redhat.com>:
> >
> >> Anton Salikhmetov wrote:
> >>
> >>> From: Anton Salikhmetov <salikhmetov@gmail.com>
> >>>
> >>> The patch contains changes for updating the ctime and mtime fields for memory mapped files:
> >>>
> >>> 1) adding a new flag triggering update of the inode data;
> >>> 2) implementing a helper function for checking that flag and updating ctime and mtime;
> >>> 3) updating time stamps for mapped files in sys_msync() and do_fsync().
> >>>
> >> Sorry, one other issue to throw out too -- an mmap'd block device
> >> should also have its inode time fields updated.  This is a little
> >> tricky because the inode referenced via mapping->host isn't the
> >> one that needs to have the time fields updated on.
> >>
> >> I have attached the patch that I submitted last.  It is quite out
> >> of date, but does show my attempt to resolve some of these issues.
> >>
> >
> > Thanks for your feedback!
> >
> > Now I'm looking at your solution and thinking about which parts of it
> > I could adapt to the infrastructure I'm trying to develop.
> >
> > However, I would like to address the block device case within
> > a separate project. But for now, I want the msync() and fsync()
> > system calls to update ctime and mtime at least for memory-mapped
> > regular files properly. I feel that even this little improvement could address
> > many customer's troubles such as the one Jacob Oestergaard reported
> > in the bug #2645.
>
> Not that I disagree and I also have customers who would really like
> to see this situation addressed so that I can then fix it in RHEL,
> but the block device issue was raised by Andrew Morton during my
> first attempt to get a patch integrated.
>
> Just so that you are aware of who has raised which issues...  :-)

Yes, I remember that email by Andrew Morton (http://lkml.org/lkml/2006/6/19/6).
In fact, I went over that thread many times while working on my
solution for this bug.

Nevertheless, I presume the block device case to be addressed in a
separate patch
series, just like the "auto-updating" feature.

>
>     Thanx...
>
>        ps
>
