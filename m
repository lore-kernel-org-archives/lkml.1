Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbYAOTEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbYAOTEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYAOTEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:04:41 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:26750 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYAOTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:04:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=x98KS35JzcAWwIQiGhMpTrasyp3QGpNfcp+csxo72bGUxUOhWxSlSawJ3HcyiYrtyUhVmjVi8cRAHPg7WWptonSb3NlGfQOFp09n7WXaZLtX5/HyCkjWq3kPNYhq9rM1aP7Bz+7xisFUzBpqoIuochlIxxuHPeeab6nm+9So5c8=
Message-ID: <4df4ef0c0801151104j5b2d003ep72600fd7553f5832@mail.gmail.com>
Date: Tue, 15 Jan 2008 22:04:38 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 2/2] Updating ctime and mtime at syncing
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu
In-Reply-To: <20080115180455.GB21557@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12004129652397-git-send-email-salikhmetov@gmail.com>
	 <1200412978699-git-send-email-salikhmetov@gmail.com>
	 <20080115180455.GB21557@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/15, Christoph Hellwig <hch@infradead.org>:
> On Tue, Jan 15, 2008 at 07:02:45PM +0300, Anton Salikhmetov wrote:
> > +/*
> > + * Update the ctime and mtime stamps for memory-mapped block device files.
> > + */
> > +static void bd_inode_update_time(struct inode *inode, struct timespec *ts)
> > +{
> > +     struct block_device *bdev = inode->i_bdev;
> > +     struct list_head *p;
> > +
> > +     if (bdev == NULL)
> > +             return;
>
> inode->i_bdev is never NULL for inodes currently beeing written to.
>
> > +
> > +     mutex_lock(&bdev->bd_mutex);
> > +     list_for_each(p, &bdev->bd_inodes) {
> > +             inode = list_entry(p, struct inode, i_devices);
>
> this should use list_for_each_entry.
>
>

Thank you very much for your recommenations. I'll take them into account.
