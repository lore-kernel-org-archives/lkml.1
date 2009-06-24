Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZF0LQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZF0LQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZF0LQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:16:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56853 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZF0LQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:16:21 -0400
Date: Wed, 24 Jun 2009 16:51:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       vapier@gentoo.org
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not
	mounted
Message-ID: <20090624145156.GC1512@ucw.cz>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com> <20090624162125.a3a9b2c4.akpm@linux-foundation.org> <1158166a0906241649u78c717c4q8aebfe16e6018e78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1158166a0906241649u78c717c4q8aebfe16e6018e78@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-25 01:49:13, Denys Vlasenko wrote:
> On Thu, Jun 25, 2009 at 1:21 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > On Thu, 25 Jun 2009 01:00:56 +0200
> > Denys Vlasenko <vda.linux@googlemail.com> wrote:
> >> In some circumstances running process needs to re-execute
> >> its image.
> ...
> >> More elegant way is to execute /proc/self/exe.
> >> This works just fine as long as /proc is mounted.
> >>
> >> But it breaks if /proc isn't mounted, and this can happen in real-world
> >> usage. For example, when shell invoked very early in initrd/initramfs.
> >
> > Why can't userspace mount /proc before doing the daemonization?
> 
> Some people want to unset CONFIG_PROC_FS, and still have
> working POSIX compatible shell. Coincidentally, NOMMU
> machines, ones which *require* re-execution of the shell to support that,
> tent to be the most memory starved machines too (thus most likely
> to be those where people desire to unset CONFIG_PROC_FS).

And some people want to mount /proc on /xyzzy.

Create minimal PROCMINI fs with just /proc/selv/exe?

> We can special-case execve(NULL, ...).
> But I feared people would say this will change previously-buggy
> userspace code into one acting weirdly; in come cases
> leading to infinite execve loops. Do you think it's better
> than "/proc/self/exe"?

Yes. Or... add execme() syscall?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
