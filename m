Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYFAV1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYFAV1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYFAV0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:26:55 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:55774 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbYFAV0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:26:54 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Rsync cannot copy to a vfat partition on kernel 2.6.25
References: <bug-449080-176318@bugzilla.redhat.com>
	<200805301659.m4UGx3AW001503@bz-web2.app.phx.redhat.com>
	<20080530171432.GA32480@redhat.com>
	<87prr36284.fsf@duaron.myhome.or.jp> <20080601203229.GA5615@ucw.cz>
	<878wxouafc.fsf@duaron.myhome.or.jp>
Date: Mon, 02 Jun 2008 06:26:49 +0900
In-Reply-To: <878wxouafc.fsf@duaron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Mon, 02 Jun 2008 06:12:23 +0900")
Message-ID: <87fxrwsv6u.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

>>> > We had a user report at https://bugzilla.redhat.com/show_bug.cgi?id=449080
>>> > that in 2.6.25, he can no longer rsync to a vfat partition, even as root.
>>> > I just reproduced this here. It gets -EPERM in the mkstemp call.
>>> > (full strace in the bug report).
>>> >
>>> > Did we change behaviour somehow in the vfat code?
>>> > 2.6.24.7 works fine apparently.
>>> 
>>> Yes, it was changed. New one allows only acceptable chmod(), and if not
>>> acceptable, it returns -EPERM. Old one allows even if it can't store the
>>> disk inode. But it may be too strict for users.
>>
>> Hmm... but I guess mkstemp is no longer safe with this?
>>
>> So we have choice between security hole and regression...?
>
> Maybe. But if users choose the group or world writable umask, I guess
> nobody would care the permission of temporary file, because all file is
> writable always. Um..

BTW, if users specified "quiet" option, FAT driver will ignore some
permission check (uid, gid, etc.).

So, another solution would be to specify this option, or change default
of it.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
