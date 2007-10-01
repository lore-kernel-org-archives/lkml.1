Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbXJAUKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbXJAUKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbXJAUKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:10:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50227 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbXJAUKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:10:31 -0400
Subject: Re: [RFC][PATCH 3/8] move mnt_want_write() out of may_open()
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <E1IcRMo-0000Qm-00@dorka.pomaz.szeredi.hu>
References: <20070928181330.27B367AC@kernel>
	 <20070928181333.F3073089@kernel> <E1IcRMo-0000Qm-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 13:10:28 -0700
Message-Id: <1191269428.6024.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 21:55 +0200, Miklos Szeredi wrote:
> > @@ -1687,10 +1679,8 @@ static int open_namei_create(struct name
> >  	struct dentry *dir = nd->dentry;
> >  
> >  	/*
> > -	 * This ensures that the mnt stays writable
> > -	 * over the vfs_create() call to may_open(),
> > -	 * which takes a more persistent
> > -	 * mnt_want_write().
> > +	 * This mnt_want_write() is potentially persistent,
> > +	 * and balanced in __fput()
> >  	 */
> >  	error = mnt_want_write(nd->mnt);
> >  	if (error) {
> 
> I'm confused: isn't it the mnt_want_write() in __dentry_open(), that
> is balanced in __fput()?

This is broken.  I didn't realize that nameidata_to_filp() called
dentry_open.  I'll rework these.

-- Dave

