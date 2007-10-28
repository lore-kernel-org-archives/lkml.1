Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbXJ1SGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbXJ1SGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXJ1SGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:06:04 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:54975 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbXJ1SGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:06:03 -0400
Date: Sun, 28 Oct 2007 14:05:16 -0400
Message-Id: <200710281805.l9SI5GoF015442@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] VFS: apply coding standards to fs/ioctl.c 
In-reply-to: Your message of "Sun, 28 Oct 2007 14:12:22 -0000."
             <20071028141222.GA29323@infradead.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071028141222.GA29323@infradead.org>, Christoph Hellwig writes:
> Nice, I always hated these double-indented switch statements.
> 
> > +	case FIBMAP:
> > +	{
> > +		struct address_space *mapping = filp->f_mapping;
> > +		int res;
> > +		/* do we support this mess? */
> > +		if (!mapping->a_ops->bmap)
> > +			return -EINVAL;
> > +		if (!capable(CAP_SYS_RAWIO))
> > +			return -EPERM;
> > +		error = get_user(block, p);
> > +		if (error)
> > +			return error;
> > +		lock_kernel();
> > +		res = mapping->a_ops->bmap(mapping, block);
> > +		unlock_kernel();
> > +		return put_user(res, p);
> 
> While you're at it, it's probably worth splitting this out into
> a small helper function.

Sure.  I assume you mean an internal function to encapsulate the entire case
statement's code, one for each of the FIO* cases.

Erez.
