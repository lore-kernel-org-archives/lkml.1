Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbYALJks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbYALJks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761487AbYALJke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:40:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761425AbYALJkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:40:31 -0500
Subject: Re: [PATCH 2/2][RFC][BUG] msync: updating ctime and mtime at
	syncing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com
In-Reply-To: <1200130565.7999.8.camel@lappy>
References: <1200006638.19293.42.camel@codedot>
	 <1200012249.20379.2.camel@codedot>  <1200130565.7999.8.camel@lappy>
Content-Type: text/plain
Date: Sat, 12 Jan 2008 10:40:44 +0100
Message-Id: <1200130844.7999.12.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-12 at 10:36 +0100, Peter Zijlstra wrote:
> On Fri, 2008-01-11 at 03:44 +0300, Anton Salikhmetov wrote:
> 
> > +/*
> > + * Update the ctime and mtime stamps after checking if they are to be updated.
> > + */
> > +void mapped_file_update_time(struct file *file)
> > +{
> > +	if (test_and_clear_bit(AS_MCTIME, &file->f_mapping->flags)) {
> > +		get_file(file);
> > +		file_update_time(file);
> > +		fput(file);
> > +	}
> > +}
> > +
> 
> I don't think you need the get/put file stuff here, because

BTW, the reason for me noticing this is that if it would be needed there
is a race condition right there, who is to say that the file pointer
you're deref'ing in your test condition isn't a dead one already.

