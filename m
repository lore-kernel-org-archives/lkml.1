Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZJZSeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZJZSeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZJZSeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:34:23 -0400
Received: from fieldses.org ([174.143.236.118]:45270 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZJZSeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:34:21 -0400
Date: Mon, 26 Oct 2009 14:35:36 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
Message-ID: <20091026183536.GE16861@fieldses.org>
References: <20091025062953.GC1391@ucw.cz> <20091026163157.GB7233@duck.suse.cz> <20091026165729.GF23564@us.ibm.com> <20091026173629.GB16861@fieldses.org> <20091026174631.GD7233@duck.suse.cz> <1256579869.8576.7.camel@heimdal.trondhjem.org> <20091025093604.GA1501@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091025093604.GA1501@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 10:36:04AM +0100, Pavel Machek wrote:
> On Mon 2009-10-26 13:57:49, Trond Myklebust wrote:
> > On Mon, 2009-10-26 at 18:46 +0100, Jan Kara wrote:
> > >   That's what I'd think as well but it does not as I've just learned and
> > > tested :) proc_pid_follow_link actually directly gives a dentry of the
> > > target file without checking permissions on the way.
> 
> It is weider. That symlink even has permissions. Those are not
> checked, either.
>  
> > I seem to remember that is deliberate, the point being that a symlink
> > in /proc/*/fd/ may contain a path that refers to a private namespace.
> 
> Well, it is unexpected and mild security hole.
> 
> Part of the problem is that even  if you have read-only
> filedescriptor, you can upgrade it to read-write, even if path is
> inaccessible to you.
> 
> So if someone passes you read-only filedescriptor, you can still write
> to it.

By the way, nfs-exporting a filesystem also allows bypassing lookup
permissions: anyone on the network can access an inode directly (using
an nfs filehandle) without necessarily traversing any path to that
inode.  (Assuming they can guess the filehandle--probably doable in most
cases.)

Not arguing for or against, just another data point.

--b.
