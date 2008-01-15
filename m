Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYAOSFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYAOSFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYAOSFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:05:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38769 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYAOSFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:05:02 -0500
Date: Tue, 15 Jan 2008 18:04:55 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu
Subject: Re: [PATCH 2/2] Updating ctime and mtime at syncing
Message-ID: <20080115180455.GB21557@infradead.org>
References: <12004129652397-git-send-email-salikhmetov@gmail.com> <1200412978699-git-send-email-salikhmetov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200412978699-git-send-email-salikhmetov@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 07:02:45PM +0300, Anton Salikhmetov wrote:
> +/*
> + * Update the ctime and mtime stamps for memory-mapped block device files.
> + */
> +static void bd_inode_update_time(struct inode *inode, struct timespec *ts)
> +{
> +	struct block_device *bdev = inode->i_bdev;
> +	struct list_head *p;
> +
> +	if (bdev == NULL)
> +		return;

inode->i_bdev is never NULL for inodes currently beeing written to.

> +
> +	mutex_lock(&bdev->bd_mutex);
> +	list_for_each(p, &bdev->bd_inodes) {
> +		inode = list_entry(p, struct inode, i_devices);

this should use list_for_each_entry.

