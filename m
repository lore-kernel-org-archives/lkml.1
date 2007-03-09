Return-Path: <linux-kernel-owner+w=401wt.eu-S1767172AbXCILNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767172AbXCILNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767173AbXCILNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:13:09 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41902 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767172AbXCILNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:13:07 -0500
Date: Fri, 9 Mar 2007 12:17:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       serue@us.ibm.com
Subject: Re: [PATCH 3/7] revoke: core code
Message-ID: <20070309121708.43758c4c@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0703091014450.32320@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703091014450.32320@sbz-30.cs.Helsinki.FI>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007 10:15:15 +0200 (EET)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The revokeat(2) and frevoke(2) system calls invalidate open file
> descriptors and shared mappings of an inode. After an successful
> revocation, operations on file descriptors fail with the EBADF or
> ENXIO error code for regular and device files,
> respectively. Attempting to read from or write to a revoked mapping
> causes SIGBUS.

Acked-by: Alan Cox <alan@redhat.com>


> +static ssize_t revoked_file_aio_read(struct kiocb *iocb,
> +				     const struct iovec *iov,
> +				     unsigned long nr_segs, loff_t pos)
> +{
> +	return -EBADF;
> +}

Do we need both -EBADF and -EXNIO versions. It is hard to tell from
existing OS's as they don't support revoke of files just special files ?

> +static ssize_t revoked_special_file_read(struct file *filp, char __user * buf,
> +					 size_t size, loff_t * ppos)
> +{
> +	return -ENXIO;
> +}

Bezerkly Unix returns 0 for the special file read case


