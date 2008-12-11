Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYLKXtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYLKXtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYLKXtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:49:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYLKXtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:49:09 -0500
Date: Thu, 11 Dec 2008 18:49:08 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] Add preadv and pwritev system calls.
Message-ID: <20081211234908.GA11305@infradead.org>
References: <49419EA7.6050308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49419EA7.6050308@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 12:13:43AM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> The attached patch adds preadv and pwritev system calls.  These syscalls
> are a pretty straightforward combination of pread and readv (same for
> write).  They are quite useful for doing vectored I/O in threaded
> applications.  Using lseek+readv instead opens race windows you'll have
> to plug with locking.
> 
> Other systems have such system calls too, for example NetBSD, check
> here: http://www.daemon-systems.org/man/preadv.2.html
> 
> The patch sports the actual system call implementation and the windup in
> the x86 system call tables.  Other archs are TBD.
> 
> Comments?  Reviews?  Suggestions?  Flames?

Looks good, but you should Cc linux-arch so that arch maintainers get
a heads up to wire up the syscalls.

> +	if (ret > 0)
> +		add_rchar(current, ret);
> +	inc_syscr(current);
> +	return ret;

Could it be that these are missing for the compat case both for the existing
readv/writev and your new syscalls?

