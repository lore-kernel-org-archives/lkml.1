Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbYKJMC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbYKJMC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbYKJMCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:02:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41536 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbYKJMCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:02:48 -0500
Date: Mon, 10 Nov 2008 07:02:47 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: remove '##' usage
Message-ID: <20081110120247.GA30377@infradead.org>
References: <20081109223542.GA16813@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109223542.GA16813@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 01:35:42AM +0300, Alexey Dobriyan wrote:
> +#define DIR(NAME, MODE, iops, fops)	\
> +	NOD(NAME, (S_IFDIR|(MODE)), &iops, &fops, {} )

This macro certainly doesn't help with readability, adding just
and S_IFDIR to the passed in arguments.

> +#define LNK(NAME, get_link)					\
>  	NOD(NAME, (S_IFLNK|S_IRWXUGO),				\
>  		&proc_pid_link_inode_operations, NULL,		\
> +		{ .proc_get_link = get_link } )
> +#define REG(NAME, MODE, fops)				\
> +	NOD(NAME, (S_IFREG|(MODE)), NULL, &fops, {})
> +#define INF(NAME, MODE, read)				\
>  	NOD(NAME, (S_IFREG|(MODE)), 			\
>  		NULL, &proc_info_file_operations,	\
> +		{ .proc_read = read } )
> +#define ONE(NAME, MODE, show)				\
>  	NOD(NAME, (S_IFREG|(MODE)), 			\
>  		NULL, &proc_single_file_operations,	\
> +		{ .proc_show = show } )

And even for these I would argue just opencoding them would be
a lot cleaner.

