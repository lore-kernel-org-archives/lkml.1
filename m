Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbYJXPz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbYJXPz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYJXPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:55:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44083 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYJXPzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:55:16 -0400
Date: Fri, 24 Oct 2008 11:55:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] proc: stop using BKL
Message-ID: <20081024155515.GA12984@infradead.org>
References: <20081024114606.GA21904@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024114606.GA21904@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 03:46:06PM +0400, Alexey Dobriyan wrote:
>     3) proc_readdir_de()
>     --------------------
>     "." and ".." part doesn't need BKL, walking PDE list is under
>     proc_subdir_lock, calling filldir callback is potentially blocking
>     because it writes to luserspace. All proc_readdir_de() callers
>     eventually come from ->readdir hook which is under directory's
>     ->i_mutex -- BKL doesn't protect anything.
>     
>     4) proc_root_readdir_de()
>     -------------------------
>     proc_root_readdir_de is ->readdir hook, see (3).
>     
>     Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Once you stop taking BKL in readdir you also need to switch to
generic_file_llseek for those directories.  It would be good if you
could switch the fallback proc_reg_llseek to no llseek at all in
proc_reg_llseek while you're at it.  I'll prepare a similar change
for non-procfs fops instances.

