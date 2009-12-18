Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbZLRRMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbZLRRMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbZLRRMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:12:36 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:60757 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbZLRRMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:12:36 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 18 Dec 2009 09:12:27 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] anonfd: Make file read-only if fops->write is not set
In-Reply-To: <20091218061049.GI18217@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0912180910450.24172@makko.or.mcafeemobile.com>
References: <adaws0k3kd8.fsf@roland-alpha.cisco.com> <20091218061049.GI18217@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009, Al Viro wrote:

> On Thu, Dec 17, 2009 at 09:46:11PM -0800, Roland Dreier wrote:
> > diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> > index 2c99459..097f91f 100644
> > --- a/fs/anon_inodes.c
> > +++ b/fs/anon_inodes.c
> > @@ -121,13 +121,13 @@ struct file *anon_inode_getfile(const char *name,
> >  	d_instantiate(path.dentry, anon_inode_inode);
> >  
> >  	error = -ENFILE;
> > -	file = alloc_file(&path, FMODE_READ | FMODE_WRITE, fops);
> > +	file = alloc_file(&path, FMODE_READ | (fops->write ? FMODE_WRITE : 0), fops);
> 
> Good grief, what for?  We are already passing O_NDELAY in flags argument,
> why not add O_RDWR/O_RDONLY to it?  It's not as if we had that many
> callers, after all...

I agree. We're better off explicitly passing the flags instead of doing 
some detection magic.


- Davide


