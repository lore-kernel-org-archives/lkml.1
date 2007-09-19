Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbXISRam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbXISRam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXISRaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:30:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53901 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761202AbXISRaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:30:01 -0400
Date: Wed, 19 Sep 2007 18:30:00 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 05/24] elevate write count open()'d files
Message-ID: <20070919173000.GE20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182724.5402E082@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182724.5402E082@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:24AM -0700, Dave Hansen wrote:
> 
> This is the first really tricky patch in the series.  It
> elevates the writer count on a mount each time a
> non-special file is opened for write.
> 
> This is not completely apparent in the patch because the
> two if() conditions in may_open() above the
> mnt_want_write() call are, combined, equivalent to
> special_file().
> 
> There is also an elevated count around the vfs_create()
> call in open_namei().  The count needs to be kept elevated
> all the way into the may_open() call.  Otherwise, when the
> write is dropped, a ro->rw transisition could occur.  This
> would lead to having rw access on the newly created file,
> while the vfsmount is ro.  That is bad.
> 
> Some filesystems forego the use of normal vfs calls to create
> struct files.  Make sure that these users elevate the mnt writer
> count because they will get __fput(), and we need to make
> sure they're balanced.

Ok.

