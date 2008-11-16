Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYKPW4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYKPW4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYKPW4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:56:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43538 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbYKPW4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:56:36 -0500
Date: Sun, 16 Nov 2008 22:56:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Peter Palfrader <peter@palfrader.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: broken ownership of /proc/sys/ files on 2.6.27
Message-ID: <20081116225633.GR28946@ZenIV.linux.org.uk>
References: <20081116205922.GI28958@anguilla.noreply.org> <20081116221910.GQ28946@ZenIV.linux.org.uk> <4920A23B.2060100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4920A23B.2060100@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 11:44:11PM +0100, Jiri Slaby wrote:
> On 11/16/2008 11:19 PM, Al Viro wrote:
> > --- a/fs/proc/proc_sysctl.c
> > +++ b/fs/proc/proc_sysctl.c
> > @@ -31,6 +31,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
> >  	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
> >  	inode->i_flags |= S_PRIVATE; /* tell selinux to ignore this inode */
> 
> And what about this    ^, is it OK?

Yes, it is.  i_flags is initialized.
