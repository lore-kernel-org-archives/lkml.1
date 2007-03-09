Return-Path: <linux-kernel-owner+w=401wt.eu-S1767205AbXCILm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767205AbXCILm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767208AbXCILm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:42:57 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53896 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767205AbXCILml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:42:41 -0500
Date: Fri, 9 Mar 2007 13:42:39 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       serue@us.ibm.com
Subject: Re: [PATCH 3/7] revoke: core code
In-Reply-To: <20070309121708.43758c4c@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0703091316550.10951@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703091014450.32320@sbz-30.cs.Helsinki.FI>
 <20070309121708.43758c4c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007 10:15:15 +0200 (EET)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> > +static ssize_t revoked_file_aio_read(struct kiocb *iocb,
> > +				     const struct iovec *iov,
> > +				     unsigned long nr_segs, loff_t pos)
> > +{
> > +	return -EBADF;
> > +}
 
On Fri, 9 Mar 2007, Alan Cox wrote:
> Do we need both -EBADF and -EXNIO versions. It is hard to tell from
> existing OS's as they don't support revoke of files just special files ?

No, we don't. We should always do EBADF except for close(2) which is zero 
always and make read(2) zero for special files.

On Fri, 9 Mar 2007 10:15:15 +0200 (EET)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> > +static ssize_t revoked_special_file_read(struct file *filp, char __user * buf,
> > +					 size_t size, loff_t * ppos)
> > +{
> > +	return -ENXIO;
> > +}

On Fri, 9 Mar 2007, Alan Cox wrote:
> Bezerkly Unix returns 0 for the special file read case

Aah, I'll fix that up. Thanks.

				Pekka
