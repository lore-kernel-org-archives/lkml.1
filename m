Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbXAXMDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbXAXMDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 07:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXAXMDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 07:03:24 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48087 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbXAXMDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 07:03:23 -0500
Date: Wed, 24 Jan 2007 13:02:35 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 5/5][AIO] - Add listio syscall support
Message-ID: <20070124130235.2591f356@frecb000686>
In-Reply-To: <20070123220433.018b40b6.akpm@osdl.org>
References: <20070117104601.36b2ab18@frecb000686>
	<20070117105554.346324b4@frecb000686>
	<20070123220433.018b40b6.akpm@osdl.org>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/01/2007 13:04:11,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/01/2007 13:04:12,
	Serialize complete at 24/01/2007 13:04:12
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 22:04:33 -0800 Andrew Morton <akpm@osdl.org> wrote:

> On Wed, 17 Jan 2007 10:55:54 +0100
> Sébastien Dugué <sebastien.dugue@bull.net> wrote:
> 
> > +void lio_check(struct lio_event *lio)
> > +{
> > +	int ret;
> > +
> > +	ret = atomic_dec_and_test(&lio->lio_users);
> > +
> > +	if (unlikely(ret) && lio->lio_notify.notify != SIGEV_NONE) {
> > +		/* last one -> notify process */
> > +		if (aio_send_signal(&lio->lio_notify))
> > +			sigqueue_free(lio->lio_notify.sigq);
> > +		kfree(lio);
> > +	}
> > +}
> 
> That's a scary function.  It may (or may not) free the memory at lio,
> returning no indication to the caller whether or not that memory is still
> allocated.  This is most peculiar - are you really sure there's no
> potential for a use-after-free here?

  Right again, this patch definitely needs more eyes peering over.

> 
> The function is poorly named: I'd expect something called "foo_check" to
> not have any side-effects.  This one has gross side-effects.  Want to think
> up a better name, please?
> 
> And given that this function has global scope, perhaps a little explanatory
> comment is in order?
> 
> > +struct lio_event *lio_create(struct sigevent __user *user_event,
> > +			int mode)
> 
> Here too.

  OK, will look into this. In the meantime, maybe you should drop this one
patch entirely.

  Thanks,

  Sébastien.
