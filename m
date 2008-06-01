Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYFAWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYFAWJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 18:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYFAWJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 18:09:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47388 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYFAWJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 18:09:10 -0400
Date: Mon, 2 Jun 2008 00:09:56 +0200
From: Pavel Machek <pavel@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Rsync cannot copy to a vfat partition on kernel 2.6.25
Message-ID: <20080601220956.GA2249@elf.ucw.cz>
References: <bug-449080-176318@bugzilla.redhat.com> <200805301659.m4UGx3AW001503@bz-web2.app.phx.redhat.com> <20080530171432.GA32480@redhat.com> <87prr36284.fsf@duaron.myhome.or.jp> <20080601203229.GA5615@ucw.cz> <878wxouafc.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wxouafc.fsf@duaron.myhome.or.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-02 06:12:23, OGAWA Hirofumi wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> > Hi!
> 
> Hi,
> 
> >> > We had a user report at https://bugzilla.redhat.com/show_bug.cgi?id=449080
> >> > that in 2.6.25, he can no longer rsync to a vfat partition, even as root.
> >> > I just reproduced this here. It gets -EPERM in the mkstemp call.
> >> > (full strace in the bug report).
> >> >
> >> > Did we change behaviour somehow in the vfat code?
> >> > 2.6.24.7 works fine apparently.
> >> 
> >> Yes, it was changed. New one allows only acceptable chmod(), and if not
> >> acceptable, it returns -EPERM. Old one allows even if it can't store the
> >> disk inode. But it may be too strict for users.
> >
> > Hmm... but I guess mkstemp is no longer safe with this?
> >
> > So we have choice between security hole and regression...?
> 
> Maybe. But if users choose the group or world writable umask, I guess
> nobody would care the permission of temporary file, because all file is
> writable always. Um..

Okay, if the user wants his vfat world-readable, it is hard to create
security hole there.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
