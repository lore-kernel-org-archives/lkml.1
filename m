Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbYAUOgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbYAUOgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 09:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYAUOgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 09:36:36 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:26870 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYAUOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:36:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZIlQjWO8GmendVOQdyhZQXmRyJUzPJHrNy+4HAtXh1hgXBTtE07AWu102yurel1YqOnxCDG7244TuwsPtX0p1yMFT9VBQyetMqRUniEMfbGf2Urn/OqCZeMiH6M20GJEGjte3CYLde2vYo1c7xBO3k6MPbSoxuIyxiBo/OnpFXw=
Message-ID: <4df4ef0c0801210636l5a68b4c1t8a2f687dcdbcf4e5@mail.gmail.com>
Date: Mon, 21 Jan 2008 17:36:34 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Peter Staubach" <staubach@redhat.com>
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped files
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Oeser" <ioe-lkml@rameria.de>,
       "Miklos Szeredi" <miklos@szeredi.hu>, peterz@infradead.org,
       linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       jesper.juhl@gmail.com, akpm@linux-foundation.org, protasnb@gmail.com,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <4794AB56.60904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	 <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>
	 <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
	 <200801182332.02945.ioe-lkml@rameria.de>
	 <alpine.LFD.1.00.0801181439330.2957@woody.linux-foundation.org>
	 <4794AB56.60904@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/21, Peter Staubach <staubach@redhat.com>:
> Linus Torvalds wrote:
> > On Fri, 18 Jan 2008, Ingo Oeser wrote:
> >
> >> Can we get "if the write to the page hits the disk, the mtime has hit the disk
> >> already no less than SOME_GRANULARITY before"?
> >>
> >> That is very important for computer forensics. Esp. in saving your ass!
> >>
> >> Ok, now back again to making that fast :-)
> >>
> >
> > I certainly don't mind it if we have some tighter guarantees, but what I'd
> > want is:
> >
> >  - keep it simple. Let's face it, Linux has never ever given those
> >    guarantees before, and it's not is if anybody has really cared. Even
> >    now, the issue seems to be more about paper standards conformance than
> >    anything else.
> >
> >
>
> I have been working on getting something supported here for
> because I have some very large Wall Street customers who do
> care about getting the mtime updated because their backups
> are getting corrupted.  They are incomplete because although
> their applications update files, they don't get backed up
> because the mtime never changes.
>
> >  - I get worried about people playing around with the dirty bit in
> >    particular. We have had some really rather nasty bugs here. Most of
> >    which are totally impossible to trigger under normal loads (for
> >    example the old random-access utorrent writable mmap issue from about
> >    a year ago).
> >
> > So these two issues - the big red danger signs flashing in my brain,
> > coupled with the fact that no application has apparently ever really
> > noticed in the last 15 years - just makes it a case where I'd like each
> > step of the way to be obvious and simple and no larger than really
> > absolutely necessary.
>
> Simple is good.  However, too simple is not good.  I would suggest
> that we implement file time updates which make sense and if they
> happen to follow POSIX, then nifty, otherwise, oh well.

Thank you very much for your support, Peter!

I'm going to submit the design document, the next version of the patch
series, and the performance tests results soon.

>
>     Thanx...
>
>        ps
>
