Return-Path: <linux-kernel-owner+w=401wt.eu-S932680AbZJ1IRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbZJ1IRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932637AbZJ1IQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:16:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60595 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591AbZJ1IQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:16:57 -0400
Date: Wed, 28 Oct 2009 09:16:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
Message-ID: <20091028081653.GA18290@elf.ucw.cz>
References: <20091025062953.GC1391@ucw.cz>
 <20091026163157.GB7233@duck.suse.cz>
 <20091026165729.GF23564@us.ibm.com>
 <20091026173629.GB16861@fieldses.org>
 <20091026174631.GD7233@duck.suse.cz>
 <1256579869.8576.7.camel@heimdal.trondhjem.org>
 <20091025093604.GA1501@ucw.cz>
 <m1zl7cb1c5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zl7cb1c5.fsf@fess.ebiederm.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-10-27 21:15:54, Eric W. Biederman wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> > On Mon 2009-10-26 13:57:49, Trond Myklebust wrote:
> >> On Mon, 2009-10-26 at 18:46 +0100, Jan Kara wrote:
> >> >   That's what I'd think as well but it does not as I've just learned and
> >> > tested :) proc_pid_follow_link actually directly gives a dentry of the
> >> > target file without checking permissions on the way.
> >
> > It is weider. That symlink even has permissions. Those are not
> > checked, either.
> >  
> >> I seem to remember that is deliberate, the point being that a symlink
> >> in /proc/*/fd/ may contain a path that refers to a private namespace.
> >
> > Well, it is unexpected and mild security hole.
> 
> /proc/<pid>/fd is only viewable by the owner of the process or by
> someone with CAP_DAC_OVERRIDE.  So there appears to be no security
> hole exploitable by people who don't have the file open.

Please see bugtraq discussion at
http://seclists.org/bugtraq/2009/Oct/179 .

(In short, you get read-only fd, and you can upgrade it to read-write
fd. Yes, you are the owner of the process, but you are not owner of
the file the fd refers to.)

> > Part of the problem is that even  if you have read-only
> > filedescriptor, you can upgrade it to read-write, even if path is
> > inaccessible to you.
> >
> > So if someone passes you read-only filedescriptor, you can still write
> > to it.
> 
> Openly if you actually have permission to open the file again.  The actual
> permissions on the file should not be ignored.

The actual permissions of the file are not ignored, but permissions of
the containing directory _are_. If there's 666 file in 700 directory,
you can reopen it read-write, in violation of directory's 700
permissions.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
