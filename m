Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYGSULl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYGSULl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 16:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYGSULd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 16:11:33 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:58354 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYGSULd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 16:11:33 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] filldir write data missing size
References: <87k5fi4l49.wl%ysato@users.sourceforge.jp>
	<871w1pn5wz.fsf@devron.myhome.or.jp>
	<87iqv1wwy1.wl%ysato@users.sourceforge.jp>
Date: Sun, 20 Jul 2008 05:11:29 +0900
In-Reply-To: <87iqv1wwy1.wl%ysato@users.sourceforge.jp> (Yoshinori Sato's
	message of "Sat, 19 Jul 2008 14:28:06 -0400")
Message-ID: <87r69pk51q.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yoshinori Sato <ysato@users.sourceforge.jp> writes:

>> > -		if (__put_user(offset, &dirent->d_off))
>> > +		if (__put_user((unsigned long)offset, &dirent->d_off))
>> 
>> Um.. __put_user() should be already doing it automatically..
>
> I'm mistake.
>
> I checked object, and found bad code.
> This problem fix __put_user.

Um.. Could you explain the detail of problem? Is this a workaround or
something for the bug of some compiler?  If so, shouldn't we fix
__put_user() instead of caller?

E.g. the following or something fixes it? (btw, this is for x86)

#define __put_user(x, ptr) ({						\
 	/* Since some compiler generates wrong code, we need __v.?? */	\
        __typeof__(*(ptr)) __v = (x);					\
	__put_user_nocheck(__v, (ptr), sizeof(*(ptr)));			\
})
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
