Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYLEJ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYLEJ7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 04:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYLEJ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 04:58:57 -0500
Received: from tundra.namei.org ([65.99.196.166]:40680 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbYLEJ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 04:58:56 -0500
Date: Fri, 5 Dec 2008 20:58:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, "Matthew N. Dodd" <matthew.dodd@sparta.com>,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 03/14] LSM/SELinux: inode_{get,set,notify}secctx hooks
 to access LSM security context information.
In-Reply-To: <1227733394-1114-4-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <alpine.LRH.1.10.0812052052480.14142@tundra.namei.org>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov> <1227733394-1114-4-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, David P. Quigley wrote:

> + * @inode_getsecctx:
> + * 	Returns a string containing all relavent security context information
> + *
> + * 	@inode we wish to set the security context of.
> + *	@ctx is a pointer in which to place the allocated security context.
> + *	@ctxlen points to the place to put the length of @ctx.
>   * This is the main security structure.
>   */
>  struct security_operations {
> @@ -1479,6 +1514,10 @@ struct security_operations {
>  	int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
>  	void (*release_secctx) (char *secdata, u32 seclen);
>  
> +	int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
> +	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
> +	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);

For inode_getsecctx(), you're returning the length via the return value, 
so you should not also need to pass in a pointer to ctxlen, right?

IMHO, it's clearer and simpler to always only return error status from 
these kinds of functions, and to pass things like size back via pointer 
args, although it seems that a few mixed return functions have crept in to 
the code over time.  My preference would be to convert it to return value 
is error status only, with the length entirely separate as a pointer arg.


- James
-- 
James Morris
<jmorris@namei.org>
