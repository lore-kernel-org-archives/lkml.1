Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbZKRTdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbZKRTdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZKRTdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:33:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51432 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbZKRTdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:33:08 -0500
Date: Wed, 18 Nov 2009 20:33:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Layton <jlayton@redhat.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] vfs: ensure that dentries are revalidated on open
 (try #2)
Message-ID: <20091118193308.GA26820@elf.ucw.cz>
References: <1257870456-31188-1-git-send-email-jlayton@redhat.com>
 <20091118041906.GB1395@ucw.cz>
 <20091118072916.720471b0@tlielax.poochiereds.net>
 <20091118173817.GE25150@elf.ucw.cz>
 <20091118135407.45b3715d@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118135407.45b3715d@tlielax.poochiereds.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Does it? Here's what I just did to check that:
> > 
> > Yes it does, see http://seclists.org/bugtraq/2009/Oct/179
...
> > /proc does not allow you to use /proc/XX/fd of unrelated users; it is
> > another mechanism disallowing access. (Plus, I did my experiments with
> > /proc/XX/fd, not /exe).

> Thanks for the info. Took me a while to get through it but I read most
> of the thread. I agree that it sounds like a very similar problem.
> 
> I'm beginning to wonder whether the right answer is to just make
> these /proc symlinks behave more like normal symlinks. Get rid of
> LAST_BIND and have follow_link turn the dentry into a path via
> d_path().

That would work for me.

> It's less efficient, but it means less special-casing in the path
> walking code. I don't see /proc symlinks as being so performance
> critical that we can't do it that way instead.

Current approach works with deleted files; without special-casing that
will stop. But I see it as a good thing: you should not have to chmod
000 before deleting a file.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
