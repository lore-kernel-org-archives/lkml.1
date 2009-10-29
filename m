Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZJ2LDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZJ2LDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 07:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZJ2LDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 07:03:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40304 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZJ2LDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 07:03:51 -0400
Date: Thu, 29 Oct 2009 12:03:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
Message-ID: <20091029110344.GA1517@ucw.cz>
References: <20091026165729.GF23564@us.ibm.com> <20091026173629.GB16861@fieldses.org> <20091026174631.GD7233@duck.suse.cz> <1256579869.8576.7.camel@heimdal.trondhjem.org> <20091025093604.GA1501@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org> <20091028081653.GA18290@elf.ucw.cz> <m1k4yfkbfg.fsf@fess.ebiederm.org> <20091028210323.GA4159@elf.ucw.cz> <m1hbtj7xgj.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbtj7xgj.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> It looks to me like it has been this way for better than a decade
> >> without problems so there is no point in changing it now.  
> >
> > Unix compatibility?
> 
> Thinking about this proc fundamentally gives you the ability to create
> (via open) a new file descriptor for a file you already have open.

Yes. Problem is that by using /proc, I can work-around open(READONLY)
restriction and work-around open(APPEND_ONLY) restriction.

> I do see a security issue in your example, but the security issue I
> see is how you have chosen to use the linux facilities, that have been
> there for ages.  Facilities cloned from plan 9 and apparently
> available in slightly different forms on many unix variants existence.
> /dev/fd/N is not a linuxism.
> 
> To close this whole would require some sort of stacking inode that
> when opened opened the real fs inode.  With all kinds of convolutions
> and complications.  Just to close the issue that some idiot might
> give someone a fd to a world writeable file that they don't want
> them to open.

Ok, so you agree issue is there. Good.

Now, fix for READONLY issue should be fairly simple: follow link in
/proc/*/fd/* should check the link permissions,  and return
read-only/write-only descriptors as neccessary.

Basically, that follow link should behave as dup(), not as open().

> I certainly am not interested in debugging or maintaining the stacking
> inode code that would be necessary to close this theoretical corner
> case.  There are much more real bugs that need attention.

But if we can get trivial 10-liner, that should be acceptable, right?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
