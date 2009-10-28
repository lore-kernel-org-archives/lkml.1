Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbZJ1VKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbZJ1VKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbZJ1VKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:10:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40003 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZJ1VKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:10:43 -0400
Date: Wed, 28 Oct 2009 22:10:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: symlinks with permissions (fwd)
Message-ID: <20091028211040.GA4182@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I forgot to cc the list)

From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: symlinks with permissions
X-Warning: Reading this can be dangerous to your mental health.

Hi!

> >> > Part of the problem is that even  if you have read-only
> >> > filedescriptor, you can upgrade it to read-write, even if path is
> >> > inaccessible to you.
> >> >
> >> > So if someone passes you read-only filedescriptor, you can still write
> >> > to it.
> >> 
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
> security would actually write code that would have a problem with this.
> 
> Do you know of any cases where this difference matters in practice?

Actually yes, see the bugtraq post. guest was able to write to my file
when I expected that file to be protected.

According to the bugtraq discussion, people expect directory
permissions to work. /proc currently breaks that. I bet there are few
systems in the wild that have permissions set up like that, but it is
not easy to actually find such systems.

Better fix it...
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

----- End forwarded message -----

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
