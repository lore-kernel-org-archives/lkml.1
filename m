Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbXITSsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbXITSsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbXITSr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:47:59 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36566 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbXITSr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:47:59 -0400
Subject: Re: [PATCH 02/24] rearrange may_open() to be r/o friendly
From: Dave Hansen <haveblue@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070919172754.GB20917@infradead.org>
References: <20070917182718.70494C9B@kernel>
	 <20070917182720.A41D6484@kernel>  <20070919172754.GB20917@infradead.org>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 11:47:56 -0700
Message-Id: <1190314076.26982.151.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 18:27 +0100, Christoph Hellwig wrote:
> >  int permission(struct inode *inode, int mask, struct nameidata *nd)
> >  {
> >  	int retval, submask;
> > +	struct vfsmount *mnt = NULL;
> > +
> > +	if (nd)
> > +		mnt = nd->mnt;
> >  
> >  	if (mask & MAY_WRITE) {
> >  		umode_t mode = inode->i_mode;
> > @@ -251,7 +255,7 @@ int permission(struct inode *inode, int 
> >  		 * MAY_EXEC on regular files is denied if the fs is mounted
> >  		 * with the "noexec" flag.
> >  		 */
> > -		if (nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))
> > +		if (mnt && (mnt->mnt_flags & MNT_NOEXEC))
> 
> Why is this entirely unrelated cleanup in this patch?
> 
> Except for that it looks fine.

You're right.  In this context, it looks completely unrelated.  I'll
separate it into another patch.

-- Dave

