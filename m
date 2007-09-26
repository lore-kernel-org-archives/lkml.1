Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbXIZSJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbXIZSJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXIZSJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:09:03 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49408 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbXIZSJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:09:01 -0400
Subject: Re: missing mnt_drop_write() on open error
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <E1Iab1W-0005Ye-00@dorka.pomaz.szeredi.hu>
References: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu>
	 <1190769669.26982.325.camel@localhost>
	 <E1IaSPW-0005M4-00@dorka.pomaz.szeredi.hu>
	 <1190823545.30530.19.camel@localhost>
	 <E1Iab1W-0005Ye-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 11:08:55 -0700
Message-Id: <1190830135.30530.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 19:50 +0200, Miklos Szeredi wrote:
> Maybe.  Can we do the mnt_want_write() from __dentry_open(), instead
> of may_open()?  That would be a lot cleaner.

I'll explore that.  It may make very good sense.

> Btw, may_open() doesn't do mnt_want_write() around the truncation if
> file is opened with O_TRUNC | O_RDONLY.

What's the path to may_open() in that case?  open_namei() should wrap
all callers other than nfs, and it does:

	/* O_TRUNC implies we need access checks for write permissions */
        if (flag & O_TRUNC)
                acc_mode |= MAY_WRITE;

Which should trigger the may_open() code.  

later in open_namei():
...
ok:
        error = may_open(nd, acc_mode, flag);
        if (error)
                goto exit;
        return 0;


-- Dave

