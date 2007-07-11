Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbXGKBoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbXGKBoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXGKBn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:43:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbXGKBn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:43:56 -0400
Date: Tue, 10 Jul 2007 18:43:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: shmem: convert to using splice instead of sendfile()
Message-Id: <20070710184347.037b6b3e.akpm@linux-foundation.org>
In-Reply-To: <200707102300.l6AN0xM4026841@hera.kernel.org>
References: <200707102300.l6AN0xM4026841@hera.kernel.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 23:00:59 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> +static int shmem_readpage(struct file *file, struct page *page)
> +{
> +	struct inode *inode = page->mapping->host;
> +	int error = shmem_getpage(inode, page->index, &page, SGP_CACHE, NULL);
> +	unlock_page(page);
> +	return error;
> +}

Worried.  shmem_getpage() does

done:
	if (*pagep != filepage) {
		unlock_page(filepage);
		*pagep = filepage;
	}
	return 0;

so we end up unlocking an unlocked page?
