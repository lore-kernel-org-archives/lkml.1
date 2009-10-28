Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZJ1VDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZJ1VDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbZJ1VD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:03:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34496 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbZJ1VD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:03:27 -0400
Date: Wed, 28 Oct 2009 22:03:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
Message-ID: <20091028210323.GA4159@elf.ucw.cz>
References: <20091025062953.GC1391@ucw.cz>
 <20091026163157.GB7233@duck.suse.cz>
 <20091026165729.GF23564@us.ibm.com>
 <20091026173629.GB16861@fieldses.org>
 <20091026174631.GD7233@duck.suse.cz>
 <1256579869.8576.7.camel@heimdal.trondhjem.org>
 <20091025093604.GA1501@ucw.cz>
 <m1zl7cb1c5.fsf@fess.ebiederm.org>
 <20091028081653.GA18290@elf.ucw.cz>
 <m1k4yfkbfg.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k4yfkbfg.fsf@fess.ebiederm.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Well, it is unexpected and mild security hole.
> >> 
> >> /proc/<pid>/fd is only viewable by the owner of the process or by
> >> someone with CAP_DAC_OVERRIDE.  So there appears to be no security
> >> hole exploitable by people who don't have the file open.
> >
> > Please see bugtraq discussion at
> > http://seclists.org/bugtraq/2009/Oct/179 .
> >
> > (In short, you get read-only fd, and you can upgrade it to read-write
> > fd. Yes, you are the owner of the process, but you are not owner of
> > the file the fd refers to.)
> 
> Assuming you have permission to open it read-write.

Please see the bugtraq discussion.

It works even if you would not have permission to write to it with
/proc unmounted.

> >> Openly if you actually have permission to open the file again.  The actual
> >> permissions on the file should not be ignored.
> >
> > The actual permissions of the file are not ignored, but permissions of
> > the containing directory _are_. If there's 666 file in 700 directory,
> > you can reopen it read-write, in violation of directory's 700
> > permissions.
> 
> I can see how all of this can come as a surprise.  However I don't see
> how any coder who is taking security seriously and being paranoid about
> security would actually write code that would have a problem with
> this.

So, there's "surprise" that gives _you_ write access to my files. You
agree that it is surprising, and you would not have write access to my
file if /proc was not mounted.

Call it "security surprise" if you prefer. But many people call it
"security hole".

> Do you know of any cases where this difference matters in practice?

No. Do you have a proof that it does not matter anywhere?

> It looks to me like it has been this way for better than a decade
> without problems so there is no point in changing it now.  

Unix compatibility?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
