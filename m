Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbXFXSUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbXFXSUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 14:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXFXSUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 14:20:00 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:44224 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269AbXFXST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 14:19:59 -0400
In-Reply-To: <20070624174732.GZ21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <b739fb9ad6e68bfe5d2a4b839abc8ea4@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Date: Sun, 24 Jun 2007 20:18:52 +0200
To: Al Viro <viro@ftp.linux.org.uk>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hopefully correct handling of integer constant expressions.  Please, 
>> review.
>
> Heh...  The first catches are lovely:
>                  struct fxsrAlignAssert {
>                          int _:!(offsetof(struct task_struct,
>                                          thread.i387.fxsave) & 15);
>                  };

That's...  wow?

> #define _IOC_TYPECHECK(t) \
>         ((sizeof(t) == sizeof(t[1]) && \
>           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
>           sizeof(t) : __invalid_size_argument_for_IOC)
> poisoning _IOW() et.al., so those who do something like
>
> static const char *v4l1_ioctls[] = {
>         [_IOC_NR(VIDIOCGCAP)]       = "VIDIOCGCAP",
>
> run into trouble.

> The only reason that doesn't break gcc to hell and back is
> that gcc has unfixed bugs in that area.

If I understand correctly what bugs you are talking about,
most (all?) of those were solved in the dark ages already
(i.e., the 3.x series).

> It certainly is not a valid C

Why not?  Nothing in the C standard says all your externs
have to be defined in some other translation unit you link
with AFAIK.

> or even a remotely sane one.

It's unusual at least :-)


Segher

