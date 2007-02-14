Return-Path: <linux-kernel-owner+w=401wt.eu-S1750990AbXBNBc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990AbXBNBc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXBNBc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:32:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:48757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbXBNBc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:32:56 -0500
Date: Tue, 13 Feb 2007 17:31:42 -0800
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH debugfs: implement symbolic links
Message-ID: <20070214013142.GB9023@suse.de>
References: <45D19D72.4050009@de.ibm.com> <20070213164551.500cd390@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213164551.500cd390@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 04:45:51PM +0100, Cornelia Huck wrote:
> On Tue, 13 Feb 2007 12:13:54 +0100,
> Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
> Not especially related to this patch (which just does the same as the
> other debugfs functions), but:
> 
> > + * If debugfs is not enabled in the kernel, the value -%ENODEV will be
> > + * returned.  It is not wise to check for this value, but rather, check for
> > + * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
> > + * code.
> 
> does not look like good advice for return code handling. Return code
> seems to be:
> 
> - ERR_PTR(-ENODEV) if debugfs is disabled
> - NULL if debugfs is enabled and something went wrong
> - !NULL and !IS_ERR if debugfs is enabled and all went fine
> 
> That makes it easy to get return code checking wrong (especially
> considering the comment above), and a number of callers do get it wrong.

They do?

The goal here is not to force the caller to care if debugfs is enabled
or not.

> How about changing the return code behaviour of the debugfs code, either
> 
> 1. return NULL if debugfs is disabled or something went wrong, !NULL
>    else or
> 2. return ERR_PTR(-ENODEV) if debugfs is disabled, ERR_PTR(-ESOMEERROR)
>    if something went wrong or a proper dentry if everything went fine?

Your proposal changes the logic, if NULL is returned, callers will not
know if this is just because debugfs is disabled (and they can continue
on just fine), or if a real error happened.

> At the very least we should change the misleading comment.

agreed, patches always welcome :)

thanks,

greg k-h
