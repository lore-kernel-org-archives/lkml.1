Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZFGGHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZFGGHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 02:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZFGGHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 02:07:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52963 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZFGGHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 02:07:32 -0400
Subject: Re: [PATCH] integrity: fix IMA inode leak
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mimi Zohar <zohar@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 02:07:30 -0400
Message-Id: <1244354850.3963.21.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-06 at 21:18 +0100, Hugh Dickins wrote:
> CONFIG_IMA=y inode activity leaks iint_cache and radix_tree_node objects
> until the system runs out of memory.  Nowhere is calling ima_inode_free()
> a.k.a. ima_iint_delete().  Fix that by calling it from destroy_inode().
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

This call was accidentally dropped in the conversion from
using the LIM hooks to embedding the IMA calls directly. I'm 
really sorry.

Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

> ---
> 
>  fs/inode.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- 2.6.30-rc8/fs/inode.c	2009-05-16 10:26:15.000000000 +0100
> +++ linux/fs/inode.c	2009-06-06 17:41:21.000000000 +0100
> @@ -219,6 +219,7 @@ static struct inode *alloc_inode(struct
>  void destroy_inode(struct inode *inode)
>  {
>  	BUG_ON(inode_has_buffers(inode));
> +	ima_inode_free(inode);
>  	security_inode_free(inode);
>  	if (inode->i_sb->s_op->destroy_inode)
>  		inode->i_sb->s_op->destroy_inode(inode);

