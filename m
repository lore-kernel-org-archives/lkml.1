Return-Path: <linux-kernel-owner+w=401wt.eu-S965310AbXCFQiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310AbXCFQiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965309AbXCFQiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:38:20 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:58587 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965310AbXCFQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:38:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FQ5H+6iQjwoo8LNHRB8LxadVCudPHpZ0MAeKJ7GSMALpCHNGO3MiYuei9/m/6LN99W0LIiWUDFXU7cyZmn4cMTvuxBpvtrS+ijDs7SPWYn17N03AkGYELb65Y7Ea9xf5r9pcv97yXpLUYDl8v4vHXeY+I5rjzMofsDrzXbVo74Y=
Message-ID: <961aa3350703060838i244469e2g7b10737343398b45@mail.gmail.com>
Date: Wed, 7 Mar 2007 01:38:17 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Akinobu Mita" <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       "Mark Fasheh" <mark.fasheh@oracle.com>,
       "Kurt Hackel" <kurt.hackel@oracle.com>
Subject: Re: [PATCH] ocfs2: fix module_init error handling
In-Reply-To: <20070305195829.GB20528@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070304133443.GA8519@APFDCB5C>
	 <20070305195829.GB20528@ca-server1.us.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/6, Joel Becker <Joel.Becker@oracle.com>:
> On Sun, Mar 04, 2007 at 10:34:43PM +0900, Akinobu Mita wrote:
> > From: Akinobu Mita <akinobu.mita@gmail.com>
> > Subject: [PATCH] ocfs2: fix module_init error handling
> >
> > Fix error handling in module_init and make module_init() return
> > correct error code.
>
>         What are you fixing specifically?  This looks like you are
> reorganizing the exit path.  While stylistic differences can exist on
> the choice of function exit, claiming there is a "fix" means there is an
> actual bug.  Please clarify the bug so we can evaluate your change.

OK. There are three problems (these are not likely to happen)

- There is no error handling when register_filesystem() fails
  (several slab caches, debugfs directory, and workqueue will not be cleaned)

- workqueue will not be cleaned if debugfs_create_dir() returns error.

- kmem_cache_destroy() with NULL oops will happen if
  ocfs2_free_mem_caches(), exit_ocfs2_uptodate_cache(),
  or exit_ocfs2_extent_maps() return error.
