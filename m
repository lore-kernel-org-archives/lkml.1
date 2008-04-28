Return-Path: <linux-kernel-owner+w=401wt.eu-S935616AbYD1PRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935616AbYD1PRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934425AbYD1PRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:17:34 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55404 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934459AbYD1PRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:17:33 -0400
Date: Mon, 28 Apr 2008 11:16:04 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/19] UML - hppfs fixes
Message-ID: <20080428151604.GB7334@c2.user-mode-linux.org>
References: <20080425175608.GA11182@c2.user-mode-linux.org> <20080426.163132.194697674.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.163132.194697674.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 04:31:32PM +0800, WANG Cong wrote:
> > -		copy_to_user(buf, &data->contents[off], count);
> > -		*ppos += count;
> > +		rem = copy_to_user(buf, &data->contents[off], count);
> > +		*ppos += count - rem;
> > +		if (rem > 0)
> > +			return -EFAULT;
> 
> 
> Could you please explain why check 'rem' after using it here?

Because I'm an idiot.  Will fix.

> >  static int hppfs_open(struct inode *inode, struct file *file)
> >  {
> >  	struct hppfs_private *data;
> > -	struct dentry *proc_dentry;
> >  	struct vfsmount *proc_mnt;
> > +	struct dentry *proc_dentry;
> 
> And what does this kind of change mean?

It means I culdn't make up my mind.  I first got rid of the dentrys,
then put them back, but in a different place.

     	      	    Jeff

-- 
Work email - jdike at linux dot intel dot com
