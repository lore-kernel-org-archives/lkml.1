Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXJ3J7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXJ3J7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJ3J7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:59:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43057 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXJ3J7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:59:39 -0400
Date: Tue, 30 Oct 2007 09:59:32 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/4] VFS: factor out three helpers for FIBMAP/FIONBIO/FIOASYNC file ioctls
Message-ID: <20071030095932.GD22413@infradead.org>
References: <11936184581182-git-send-email-ezk@cs.sunysb.edu> <11936184593537-git-send-email-ezk@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11936184593537-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int __ioctl_fibmap(struct file *filp, int __user *p)

I'd say kill the __ prefix for all the functions you're adding.

> +static int __ioctl_fionbio(struct file *filp, unsigned long arg)

> +static int __ioctl_fioasync(unsigned int fd, struct file *filp,
> +			    unsigned long arg)

For these two I'd add a

	void __user *argp = (void __user *)arg;

in the caller and then just pass argp down.  That way we have the cast in
one place.

