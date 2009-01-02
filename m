Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbZABORc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbZABORc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZABORY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:17:24 -0500
Received: from kumera.dghda.com ([80.68.90.171]:57066 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbZABORX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:17:23 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Fri, 2 Jan 2009 14:17:17 +0000
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Duane Griffin <duaneg@dghda.com>, Evgeniy Dushistov <dushistov@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ufs: copy symlink data into the correct union
	member
Message-ID: <20090102141717.GB5814@dastardly.home.dghda.com>
References: <1230742208-23972-1-git-send-email-duaneg@dghda.com> <1230742208-23972-2-git-send-email-duaneg@dghda.com> <1230742208-23972-3-git-send-email-duaneg@dghda.com> <1230742208-23972-4-git-send-email-duaneg@dghda.com> <20090101023620.GD28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090101023620.GD28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 02:36:20AM +0000, Al Viro wrote:
> On Wed, Dec 31, 2008 at 04:50:08PM +0000, Duane Griffin wrote:
> > Copy symlink data into the union member it is accessed through. Although
> > this shouldn't make a difference to behaviour it makes the code easier
> > to follow and grep through. It may also prevent problems if the
> > struct/union definitions change in the future.
> > 
> > Signed-off-by: Duane Griffin <duaneg@dghda.com>
> > ---
> >  fs/ufs/namei.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
> > index e3a9b1f..3884730 100644
> > --- a/fs/ufs/namei.c
> > +++ b/fs/ufs/namei.c
> > @@ -147,7 +147,7 @@ static int ufs_symlink (struct inode * dir, struct dentry * dentry,
> >  	} else {
> >  		/* fast symlink */
> >  		inode->i_op = &ufs_fast_symlink_inode_operations;
> > -		memcpy((char*)&UFS_I(inode)->i_u1.i_data,symname,l);
> > +		memcpy((char *) &UFS_I(inode)->i_u1.i_symlink, symname, l);
> 
> Just what are these cast and & doing there?  i_symlink is an array of u8,
> for fsck sake; taking its address is a pointless obfuscation.  And memcpy()
> is just as fine with u8 * as it is with char *...

Ahem. Good points. I neglected to clean-up properly, sorry. Will redo
and resend once we've got agreement on the other issues.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
