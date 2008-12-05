Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYLEPrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYLEPrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbYLEPrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:47:09 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:50305 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbYLEPrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:47:08 -0500
Subject: Re: [PATCH 03/14] LSM/SELinux: inode_{get,set,notify}secctx hooks
	to access LSM security context information.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, "Matthew N. Dodd" <matthew.dodd@sparta.com>,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
In-Reply-To: <alpine.LRH.1.10.0812052052480.14142@tundra.namei.org>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1227733394-1114-4-git-send-email-dpquigl@tycho.nsa.gov>
	 <alpine.LRH.1.10.0812052052480.14142@tundra.namei.org>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 10:25:12 -0500
Message-Id: <1228490712.15920.45.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 20:58 +1100, James Morris wrote:
> On Wed, 26 Nov 2008, David P. Quigley wrote:
> 
> > + * @inode_getsecctx:
> > + * 	Returns a string containing all relavent security context information
> > + *
> > + * 	@inode we wish to set the security context of.
> > + *	@ctx is a pointer in which to place the allocated security context.
> > + *	@ctxlen points to the place to put the length of @ctx.
> >   * This is the main security structure.
> >   */
> >  struct security_operations {
> > @@ -1479,6 +1514,10 @@ struct security_operations {
> >  	int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
> >  	void (*release_secctx) (char *secdata, u32 seclen);
> >  
> > +	int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
> > +	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
> > +	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
> 
> For inode_getsecctx(), you're returning the length via the return value, 
> so you should not also need to pass in a pointer to ctxlen, right?
> 
> IMHO, it's clearer and simpler to always only return error status from 
> these kinds of functions, and to pass things like size back via pointer 
> args, although it seems that a few mixed return functions have crept in to 
> the code over time.  My preference would be to convert it to return value 
> is error status only, with the length entirely separate as a pointer arg.
> 
> 
> - James

I'll have to look into why we did it this way. The discussion for these
patches happened many months ago so I don't remember why it was done
this way. I remember at the time getting an approval for the approach
but a desire not to merge the patch while there were no users of it.

Dave

