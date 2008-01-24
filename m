Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbYAXHgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbYAXHgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYAXHgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:36:31 -0500
Received: from brick.kernel.dk ([87.55.233.238]:7738 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbYAXHg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:36:27 -0500
Date: Thu, 24 Jan 2008 08:36:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, knikanth@novell.com
Subject: Re: [PATCH 2/6] io context sharing: preliminary support
Message-ID: <20080124073624.GO6258@kernel.dk>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com> <1200995361-24001-3-git-send-email-jens.axboe@oracle.com> <20080123140803.ff320a96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123140803.ff320a96.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23 2008, Andrew Morton wrote:
> > On Tue, 22 Jan 2008 10:49:17 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> > -void put_io_context(struct io_context *ioc)
> > +int put_io_context(struct io_context *ioc)
> >  {
> >  	if (ioc == NULL)
> > -		return;
> > +		return 1;
> >  
> >  	BUG_ON(atomic_read(&ioc->refcount) == 0);
> >  
> > @@ -3856,7 +3856,9 @@ void put_io_context(struct io_context *ioc)
> >  		rcu_read_unlock();
> >  
> >  		kmem_cache_free(iocontext_cachep, ioc);
> > +		return 1;
> >  	}
> > +	return 0;
> >  }
> 
> Document the return value?  (and the function)

Will do.

> I assume this return value gets used in some other patch.

Yeah, it is.

-- 
Jens Axboe

