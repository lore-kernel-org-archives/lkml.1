Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbYALNvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbYALNvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 08:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYALNv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 08:51:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:17385 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYALNv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 08:51:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k8bWj/XRa+K7J9SkOw2obUbdxnJRoQ0w6WYCVeaLcT4Y7+V+/GEwFx7Um8fqh4Sxb9A1DQw5s7HqcYV/RvPDEzTKjABklGTTEtqKVor2ArJPS9S57CgaIJOF8Dr6tir2QkHKnlxjZnn1xODjvawqXUjtqAdM0vk7PoUk3I5/ang=
Message-ID: <4df4ef0c0801120551k29279354vd724b6750fda2c00@mail.gmail.com>
Date: Sat, 12 Jan 2008 16:51:28 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2][RFC][BUG] msync: updating ctime and mtime at syncing
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com
In-Reply-To: <1200143342.7999.25.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200006638.19293.42.camel@codedot>
	 <1200012249.20379.2.camel@codedot> <1200130565.7999.8.camel@lappy>
	 <1200130844.7999.12.camel@lappy>
	 <4df4ef0c0801120438n4a3c1cfpd3563531929a1a91@mail.gmail.com>
	 <1200143342.7999.25.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/12, Peter Zijlstra <a.p.zijlstra@chello.nl>:
>
> On Sat, 2008-01-12 at 15:38 +0300, Anton Salikhmetov wrote:
> > 2008/1/12, Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > >
> > > On Sat, 2008-01-12 at 10:36 +0100, Peter Zijlstra wrote:
> > > > On Fri, 2008-01-11 at 03:44 +0300, Anton Salikhmetov wrote:
> > > >
> > > > > +/*
> > > > > + * Update the ctime and mtime stamps after checking if they are to be updated.
> > > > > + */
> > > > > +void mapped_file_update_time(struct file *file)
> > > > > +{
> > > > > +   if (test_and_clear_bit(AS_MCTIME, &file->f_mapping->flags)) {
> > > > > +           get_file(file);
> > > > > +           file_update_time(file);
> > > > > +           fput(file);
> > > > > +   }
> > > > > +}
> > > > > +
> > > >
> > > > I don't think you need the get/put file stuff here, because
> > >
> > > BTW, the reason for me noticing this is that if it would be needed there
> > > is a race condition right there, who is to say that the file pointer
> > > you're deref'ing in your test condition isn't a dead one already.
> >
> > So, in your opinion, is it at all needed here to play with the file reference
> > counter? May I drop the get_file() and fput() calls from the
> > sys_msync() function?
>
> No, the ones in sys_msync() around calling do_fsync() are most
> definately needed because we release mmap_sem there.
>
> What I'm saying is that you can remove the get_file()/fput() calls from
> your new mapped_file_update_time() function.

OK, thank you very much for your answer. I'm planning to submit my
next solution which is going to take your suggestion into account.

But I'm not sure how to process memory-mapped block device files.
Staubach's approach did not work for me after adapting it to my
solution.

>
>
