Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbXJZUWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbXJZUWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJZUWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:22:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:51583 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbXJZUWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:22:45 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [AppArmor 32/45] Enable LSM hooks to distinguish operations on file descriptors from operations on pathnames
Date: Fri, 26 Oct 2007 22:24:45 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <20071026064024.243943043@suse.de> <20071026064051.393728475@suse.de> <1193398252.4721.7.camel@localhost>
In-Reply-To: <1193398252.4721.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710262224.45773.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 13:30, Miklos Szeredi wrote:
> There's a slight problem (other than HCH not liking it) with this
> approach of passing the open file in iattr:  for special files, the
> struct file pointer makes no sense to the filesystem, since it is always
> opened by the generic functions.

So what do you think where the inodes come from for syscalls like fchmod? Out 
of struct file, of course. But your f_op->getattr and f_op->setattr patches 
are meant for passing struct file down to filesystems anyway, so that 
completely contradicts what you are saying above.

> So I think the correct solution (which was suggested by Trond and
> others) is to define an f_op->fsetattr() method, which interested
> filesystems can define.

That's nothing but a replacement for ATTR_FILE and iattr->ia_file. Except by 
removing the ATTR_FILE flag, LSMs will no longer get that information for 
distinguishing file descriptor operations from other operations.

AppArmor needs to know when notify_change is called on a file descriptor, but 
it doesn't care about the file descriptor itself. So any way of passing along 
that information will be fine.

Thanks,
Andreas
