Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbYIBNLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbYIBNLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYIBNLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:11:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59825 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYIBNLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:11:38 -0400
Date: Tue, 2 Sep 2008 08:11:27 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: (repost) Confirmation of methods for calculating requested pathname.
Message-ID: <20080902131127.GA5951@hallyn.com>
References: <48AA49DE.6000006@nttdata.co.jp> <48BCC1B6.5030901@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BCC1B6.5030901@nttdata.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> Al, could you answer the following question?
> 
> 
> The current Linux kernel is not designed to pass vfsmount parameter
> that is crucial for pathname-based security including AppArmor and
> TOMOYO Linux, to LSM. Though both projects have been proposing
> patches to calculate pathname, none of them have been accepted as
> you know.
> 
> To find the reason for NACK, we examined past proposals and the
> threads. And we came to understand that you oppose accessing vfsmount
> inside vfs helper functions. Is our understanding correct?
> 
> If our understanding is correct, we would like to propose a new
> method that does not require modifications to vfs helper functions.
> Attached patch is a trial of this method.
> 
> vfs helper functions are surrounded by mnt_want_write() and
> mnt_drop_write() pairs which receive "struct vfsmount" parameter

I thought Al and others (Stephen?) had made it clear that the thing to do was
add new lsm hooks there.  So whereas inode_permission takes only an inode and
ends up calling security_inode_permission, you would add a
security_path_permission() or somesuch before or after the call to
inode_permission(), where as you've noted the path is available.  You're
*close* to doing the right thing by having a helper who is called at the right
place catch the vfsmount, but you refuse to send a patch doing exactly what
has been suggested.

-serge
