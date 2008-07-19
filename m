Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYGSRYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYGSRYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 13:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYGSRYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 13:24:34 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:47246 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYGSRYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 13:24:34 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] filldir write data missing size
References: <87k5fi4l49.wl%ysato@users.sourceforge.jp>
Date: Sun, 20 Jul 2008 02:24:28 +0900
In-Reply-To: <87k5fi4l49.wl%ysato@users.sourceforge.jp> (Yoshinori Sato's
	message of "Fri, 18 Jul 2008 23:18:46 -0400")
Message-ID: <871w1pn5wz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yoshinori Sato <ysato@users.sourceforge.jp> writes:

> "loff_t" is long long.
> But "d_off" is unsigned long.
>
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
>
> diff --git a/fs/readdir.c b/fs/readdir.c
> index 4e026e5..01e7152
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -159,7 +159,7 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
>  		return -EOVERFLOW;
>  	dirent = buf->previous;
>  	if (dirent) {
> -		if (__put_user(offset, &dirent->d_off))
> +		if (__put_user((unsigned long)offset, &dirent->d_off))

Um.. __put_user() should be already doing it automatically..

>  			goto efault;
>  	}
>  	dirent = buf->current_dir;
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
