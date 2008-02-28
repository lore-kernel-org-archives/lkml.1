Return-Path: <linux-kernel-owner+w=401wt.eu-S1760754AbYB1QtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754AbYB1QtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbYB1QtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:49:06 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:55546 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbYB1QtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:49:05 -0500
Subject: Re: [PATCH 08/11] NFS: Introduce lifecycle management for label
	attribute.
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Matthew.Dodd@sparta.com
In-Reply-To: <Xine.LNX.4.64.0802281451380.7262@us.intercode.com.au>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204150294-4678-9-git-send-email-dpquigl@tycho.nsa.gov>
	 <Xine.LNX.4.64.0802281451380.7262@us.intercode.com.au>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:24:35 -0500
Message-Id: <1204215875.24345.65.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to CC Matt on the posting of the patch set (I figured he was on
fsdevel or lkml) so I asked him about this and here is the response.

"The allocation flag used depends on where the call is made.
In some cases allocation is not permitted to wait, etc."

I'm assuming he felt that the sections marked NOWAIT could not wait for
memory allocation. If people want to review them, and find to the
contrary we can figure out what the correct ones are.

Dave

On Thu, 2008-02-28 at 15:13 +1100, James Morris wrote:
> On Wed, 27 Feb 2008, David P. Quigley wrote:
> 
> > +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> > +	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL))
> > +		nfs_fattr_alloc(&fattr, GFP_NOWAIT);
> > +#endif
> 
> There are at least ten instances of the above.  (Why do some of them use 
> GFP_NOWAIT ?)
> 
> > +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> > +	if (server->caps & NFS_CAP_SECURITY_LABEL) {
> > +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> > +		nfs_fattr_alloc(&dir_fattr, GFP_KERNEL);
> > +	}
> 
> And a few of these.
> 
> Static inline them, please.
> 
> > +#define	nfs_fattr_alloc(fattr, flags)
> > +#define	nfs_fattr_fini(fattr)
> 
> The preferred way to do this in Linux is as a static inline.
> 
> 
> - James

