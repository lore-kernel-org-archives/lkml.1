Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZKTJvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZKTJvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZKTJvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:51:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44748 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZKTJvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:51:31 -0500
Date: Fri, 20 Nov 2009 10:51:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jlayton@redhat.com, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] procfs: make /proc style symlinks behave like "normal"
 symlinks
Message-ID: <20091120095129.GD11212@elf.ucw.cz>
References: <1258638251-20034-1-git-send-email-jlayton@redhat.com>
 <m14ooq5tq3.fsf@fess.ebiederm.org>
 <20091119132833.30bc93a4@barsoom.rdu.redhat.com>
 <m1skca2vi3.fsf@fess.ebiederm.org>
 <20091119143555.7851953f@barsoom.rdu.redhat.com>
 <20091119213935.GA11212@elf.ucw.cz>
 <E1NBPq8-0001D7-F9@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NBPq8-0001D7-F9@pomaz-ex.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-11-20 10:31:40, Miklos Szeredi wrote:
> On Thu, 19 Nov 2009, Pavel Machek wrote:
> > > Adding the missing revalidations is fine, but I don't believe that
> > > helps to fix Pavel's issue. I'll go back and take a more careful look
> > > at the suggestion that Miklos made and see whether it makes sense to
> > > implement a new FS_* flag for this, and see what it'll take to fix
> > > Pavel's issue.
> 
> What is this "Pavel's issue"?

The one we were talking about, see bugtraq.

> > One posibility would be to make open(/proc/XX/fd/XX) behave like
> > dup(). That should solve the NFS problems, too, no?
> 
> You mean, reuse the old "struct file" for the new open?  Or what?

Aha, dup() results in file position being shared. You are right,
that's not going to fly :-(.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
