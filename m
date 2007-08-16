Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbXHPW7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbXHPW7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXHPW65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:58:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46112 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388AbXHPW6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:58:55 -0400
Date: Thu, 16 Aug 2007 15:57:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: viro@ftp.linux.org.uk, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: Adding a security parameter to VFS functions
In-Reply-To: <29015.1187178055@redhat.com>
Message-ID: <alpine.LFD.0.999.0708161550140.30176@woody.linux-foundation.org>
References: <29015.1187178055@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Aug 2007, David Howells wrote:
> 
> Would you object greatly to functions like vfs_mkdir() gaining a security
> parameter?  What I'm thinking of is this:
> 
> 	int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
> 		      struct security *security)

I personally consider this an affront to everythign that is decent.

Why the *hell* would mkdir() be so magical as to need something like that?

Make it something sane, like a "struct nameidata" instead, and make it at 
least try to look like the path creation that is done by "open()".  Or 
create a "struct file *" or something.

I can imagine having "mkdir()" being passed similar data as "open()" (ie 
"lookup()"), but I cannot _possibly_ imagine it ever being valid to pass 
in something totally made-up to just mkdir(), and nothing else. There's 
something fundamentally wrong there.

What makes mkdir() so magical?

Also, what about all the other ops? Why is mkdir() special, but not 
"mknod()"? Why is "mkdir()" special, but not "rmdir()"? Really, none of 
this seems to make any sense unless you describe what is so magical about 
mkdir().

		Linus
