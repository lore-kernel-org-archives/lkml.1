Return-Path: <linux-kernel-owner+w=401wt.eu-S1763445AbYALMiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763445AbYALMiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 07:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761542AbYALMin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 07:38:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:34493 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYALMim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 07:38:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a+IKCWSuYYXPnkvNullbz7ceChkChI1re1vQcdzNmcHB0UQ4CpzSUj+odYpSTAANc0Rr6lMZyS+p1esdWdVRX6IF14Q2gvxEHf3/A6nC191iO/gAc5l3yfSbEfqYpV9zNEmLR0zrnBVnMIYOx3HFfA4tdlWms24Q5CRKxKhKeLQ=
Message-ID: <4df4ef0c0801120438n4a3c1cfpd3563531929a1a91@mail.gmail.com>
Date: Sat, 12 Jan 2008 15:38:41 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2][RFC][BUG] msync: updating ctime and mtime at syncing
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com
In-Reply-To: <1200130844.7999.12.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200006638.19293.42.camel@codedot>
	 <1200012249.20379.2.camel@codedot> <1200130565.7999.8.camel@lappy>
	 <1200130844.7999.12.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/12, Peter Zijlstra <a.p.zijlstra@chello.nl>:
>
> On Sat, 2008-01-12 at 10:36 +0100, Peter Zijlstra wrote:
> > On Fri, 2008-01-11 at 03:44 +0300, Anton Salikhmetov wrote:
> >
> > > +/*
> > > + * Update the ctime and mtime stamps after checking if they are to be updated.
> > > + */
> > > +void mapped_file_update_time(struct file *file)
> > > +{
> > > +   if (test_and_clear_bit(AS_MCTIME, &file->f_mapping->flags)) {
> > > +           get_file(file);
> > > +           file_update_time(file);
> > > +           fput(file);
> > > +   }
> > > +}
> > > +
> >
> > I don't think you need the get/put file stuff here, because
>
> BTW, the reason for me noticing this is that if it would be needed there
> is a race condition right there, who is to say that the file pointer
> you're deref'ing in your test condition isn't a dead one already.

So, in your opinion, is it at all needed here to play with the file reference
counter? May I drop the get_file() and fput() calls from the
sys_msync() function?

>
>
