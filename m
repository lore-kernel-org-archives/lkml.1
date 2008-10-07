Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYJGQwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYJGQwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYJGQvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:51:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35630 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbYJGQvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:51:54 -0400
Subject: Re: [RFC PATCH] i_version: remount support
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081007114817.GA7024@infradead.org>
References: <10dbd13724581b0dca8d77ae944aaf3c70b93137.1223341927.git.zohar@linux.vnet.ibm.com>
	 <20081007114817.GA7024@infradead.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 12:51:52 -0400
Message-Id: <1223398312.3101.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 07:48 -0400, Christoph Hellwig wrote:
> On Tue, Oct 07, 2008 at 07:30:48AM -0400, Mimi Zohar wrote:
> > Add support for remounting a filesystem with the i_version option.
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > ---
> > diff --git a/fs/super.c b/fs/super.c
> > index e931ae9..3758cbe 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -641,6 +641,8 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
> >  			return retval;
> >  	}
> >  	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
> > +	if (flags & MS_I_VERSION)
> > +		sb->s_flags |= MS_I_VERSION;
> 
> The proper way would be to add it to MS_RMT_MASK.
> 

That works. Here's the replacement patch.

Thanks!

Mimi

Add support for remounting a filesystem with the i_version option.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Index: security-testing-2.6/include/linux/fs.h
===================================================================
--- security-testing-2.6.orig/include/linux/fs.h
+++ security-testing-2.6/include/linux/fs.h
@@ -134,7 +134,7 @@ extern int dir_notify_enable;
 /*
  * Superblock flags that can be altered by MS_REMOUNT
  */
-#define MS_RMT_MASK	(MS_RDONLY|MS_SYNCHRONOUS|MS_MANDLOCK)
+#define MS_RMT_MASK	(MS_RDONLY|MS_SYNCHRONOUS|MS_MANDLOCK|MS_I_VERSION)
 
 /*
  * Old magic mount flag and mask


