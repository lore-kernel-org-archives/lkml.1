Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZJZRqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZJZRqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZJZRqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:46:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZJZRq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:46:27 -0400
Date: Mon, 26 Oct 2009 18:46:31 +0100
From: Jan Kara <jack@suse.cz>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Jan Kara <jack@suse.cz>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
Message-ID: <20091026174631.GD7233@duck.suse.cz>
References: <20091025062953.GC1391@ucw.cz> <20091026163157.GB7233@duck.suse.cz> <20091026165729.GF23564@us.ibm.com> <20091026173629.GB16861@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026173629.GB16861@fieldses.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26-10-09 13:36:29, J. Bruce Fields wrote:
> On Mon, Oct 26, 2009 at 11:57:29AM -0500, Serge E. Hallyn wrote:
> > Quoting Jan Kara (jack@suse.cz):
> > >   Hi,
> > > 
> > > On Sun 25-10-09 07:29:53, Pavel Machek wrote:
> > > > ...yes, they do exist, in /proc/self/fd/* . Unfortunately, their
> > > > permissions are not actually checked during open, resulting in
> > > > (obscure) security hole: if you have fd open for reading, you can
> > > > reopen it for write, even through unix permissions would not allow
> > > > that.
> > > > 
> > > > Now... I'd like to close the hole. One way would be to actually check
> > > > symlink permissions on open -- because those symlinks already have
> > > > correct permissions.
> > >   Hmm, I'm not sure I understand the problem. Symlink is just a file
> > > containing a path. So if you try to open a symlink, you will actually open
> > > a file to which the path points. So what security problem is here? Either
> > > you can open the file symlink points to for writing or you cannot...
> > >   Anyway, if you want to play with this,
> > > fs/proc/base.c:proc_pid_follow_link
> > >   is probably the function you are interested in.
> > 
> > The problem he's trying to address is that users may try to protect
> > a file by doing chmod 700 on the parent dir, but leave the file itself
> > accessible.  They don't realize that merely having a task with an open
> > fd to that file gives other users another path to the file.
> > 
> > Whether or not that's actually a problem is open to debate, but I think
> > he's right that many users aren't aware of it.
> 
> If /proc/self/fd/23 is a symlink to /home/me/privatedir/secret, then an
> open("proc/self/fd/23",...) still traverses the whole /home/.../secret
> path, and needs appropriate permissions at each step, doesn't it?
> 
> Probably I'm just terminally confused....
  That's what I'd think as well but it does not as I've just learned and
tested :) proc_pid_follow_link actually directly gives a dentry of the
target file without checking permissions on the way.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
