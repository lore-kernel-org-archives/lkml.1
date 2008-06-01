Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYFAUoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYFAUoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYFAUoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:44:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2042 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751783AbYFAUoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:44:07 -0400
Date: Sun, 1 Jun 2008 22:32:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Rsync cannot copy to a vfat partition on kernel 2.6.25
Message-ID: <20080601203229.GA5615@ucw.cz>
References: <bug-449080-176318@bugzilla.redhat.com> <200805301659.m4UGx3AW001503@bz-web2.app.phx.redhat.com> <20080530171432.GA32480@redhat.com> <87prr36284.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prr36284.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > We had a user report at https://bugzilla.redhat.com/show_bug.cgi?id=449080
> > that in 2.6.25, he can no longer rsync to a vfat partition, even as root.
> > I just reproduced this here. It gets -EPERM in the mkstemp call.
> > (full strace in the bug report).
> >
> > Did we change behaviour somehow in the vfat code?
> > 2.6.24.7 works fine apparently.
> 
> Yes, it was changed. New one allows only acceptable chmod(), and if not
> acceptable, it returns -EPERM. Old one allows even if it can't store the
> disk inode. But it may be too strict for users.

Hmm... but I guess mkstemp is no longer safe with this?

So we have choice between security hole and regression...?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
