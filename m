Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbYEAQ07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbYEAQ07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYEAQ0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:26:50 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37526 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYEAQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:26:49 -0400
Subject: Re: [RFC][PATCH 4/5] must hold lock_super() to set initial mount
	writer
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, trond.myklebust@fys.uio.no
In-Reply-To: <E1Jr8ZK-0001uW-4s@pomaz-ex.szeredi.hu>
References: <20080429185943.3BA6A050@kernel>
	 <20080429185948.F5D2E512@kernel>  <E1Jr8ZK-0001uW-4s@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Thu, 01 May 2008 09:26:44 -0700
Message-Id: <1209659204.4461.65.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 11:25 +0200, Miklos Szeredi wrote:
> > We need lock_mnt_writers() during a remount in order
> > to keep mnt->__mnt_writers from changing so that we
> > get a consistent look at if a sb currently has anyone
> > writing to it.
> > 
> > But, we need to lock writers out for an extended
> > period, even during the ->remount_fs() operation.
> > That's because we do conclusively make the fs
> > r/o until *after* the ->remount_fs().
> 
> So?  Why don't we mark the fs r/o _before_ calling ->remount_fs() and
> if that fails, just mark it r/w again.
> 
> OK, we'll deny writes in that interval, but I don't see that as a big
> problem.  And it would simplify the implementation considerably.

Personally, I think that's a bit messy.  People might start getting
-EROFS when they never, ever *HAD* a r/o FS.  They may have made a
request for one, but they never actually hard one.

I also understand what you're saying.  If we were able to loosen up some
of the requirements it would certainly make the patches simpler.  How
does everyone else feel about this?

-- Dave

