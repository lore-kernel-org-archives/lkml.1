Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbXH3XbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbXH3XbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 19:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbXH3XbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 19:31:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:16135 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbXH3XbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 19:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=OM43Uc7gC6t6Ckubg31vs6X7a2ym76ruMBXceg7tvtNNiqUY0xW1CQ4xrTTV0Ffg5kOj8MGSkmkpUyR+CSKO/JVzoNJtqBScJP1swu8e14r4L8ZWL4pDOWBe9GST1UOFW/peJxLg7bWZzHEFDIocpUo16JQYRxjImILE2XinLgY=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Trond Myklebust'" <trond.myklebust@fys.uio.no>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>	 <1188513433.6626.24.camel@heimdal.trondhjem.org>	 <001001c7eb57$afd2d320$0f787960$@com> <1188516173.6626.46.camel@heimdal.trondhjem.org>
In-Reply-To: <1188516173.6626.46.camel@heimdal.trondhjem.org>
Subject: RE: recent nfs change causes autofs regression
Date: Thu, 30 Aug 2007 16:30:57 -0700
Message-ID: <001501c7eb5d$d295d870$77c18950$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfrXLIM3BURGc1XTOGI3dO6ZO+FkgAAFyMA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2007-08-30 at 15:47 -0700, Hua Zhong wrote:
> > >
> > > Which is better than having it fail silently, or giving you a mount
> > > with the wrong mount options.
> >
> > Well, it depends on how you define "better".
> 
> "better" as in: "I now have a chance to notice, when my 'read-only
> mount' is actually 'read-write'".
> 
> > In this particular scenario, the maps read as follows:
> >
> > tools
> > -
> fstype=nfs,udp,rw,intr,nosuid,nodev,rsize=8192,wsize=8192,mountvers=3,n
> fsve
> > rs=3,actimeo=600 fs1.domain.com:/a/tools
> > share
> > -
> fstype=nfs,udp,rw,intr,nosuid,nodev,rsize=8192,wsize=8192,mountvers=3,n
> fsve
> > rs=3 fs1.domain.com:/a/share
> >
> > The only difference is in the actimeo (I don't even know what it
> > means). Is this enough to fail a mount?
> 
> Yes. The default values for acregmin, acregmax, acdirmin, acdirmax are
> not 600. If /a/tools and /a/share are on the same filesystem on the
> server, then the NFS client should warn you that you are about to do
> something that may result in cache coherency problems instead of
> silently allowing it, and then leaving you to debug the coherency issue.

There are two disjoint directories. I am wondering why there would be cache
coherency issues in this case? Is this Linus nfs implementation specific or
all other Unix systems all have the same issue?

> If you know what you are doing, then there is an option which allows
> you to override the default behaviour.
> 
> > More importantly, it is a regression. My understanding is that unless
> > absolutely necessary we do not introduce a "feature" that breaks
> > working setups.
> 
> Your turn to define what you mean by "working"? In my book that means
> "a setup that doesn't include unexpected or unintended behaviour".

"working" as in "I can mount the directory and do my work". And there has
never been any problems as far as I know.

> Not being able to notice cache coherency failures on a file that is
> mounted in two different places with two different sets of mount
> options counts as "unexpected behaviour".
> 
> Not being able to notice that your mount options have been overridden
> by the kernel also counts as "unexpected behaviour".

Fine. These are all very nice theories, but I just want to report this
regression and hope it won't cause any big problems for any users out there.
In the mean time, I am returning to 2.6.22.

> Trond

