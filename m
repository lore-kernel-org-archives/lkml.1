Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYIBAeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYIBAeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 20:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYIBAeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 20:34:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:49050 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYIBAeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 20:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UQ+nsMutNxbz/7PBl2dJ/3HgBWXIRX+XQ+IITzfS+rKXPAPll/yOEUZ4+GK4fzCRm7
         7UbVUHEKSseVbj7S3ZCxv1CZgss8LIyq1tQ6wkZiWIk7ucawpEKZxYpBoKkGbQkBNRCv
         hNTiNoikg1y0xiymCNH1e7B0AZm7zC7KnP6VI=
Message-ID: <a36005b50809011734w73f48dc1l68853e4e73309c2a@mail.gmail.com>
Date: Mon, 1 Sep 2008 17:34:03 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Subject: Re: No NONBLOCK flag for dup3() or epoll_create1()?
Cc: "Ulrich Drepper" <drepper@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       "Davide Libenzi" <davidel@xmailserver.org>
In-Reply-To: <48AC4B19.6000206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AC4B19.6000206@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 9:49 AM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> I've been doing some testing (2.6.27-rc3) of your new
> file-descriptor-creating syscalls that accept flags.  According to
>
> http://udrepper.livejournal.com/20407.html
>
> all of the system calls should accept a *_NONBLOCK flag.

This was never the intention.


> For epoll_create1() this certainly appears to be an oversight, since I can't
> think of a reason not to support *_NONBLOCK.

I can.  There is already a method to not block (zero timeout).  We
should not provide multiple ways to get the same functionality.  It
would require changes in the epoll code as well.  That's not worth it.


>  (Furthermore, given a open file description for which O_NONBLOCK is
> already enabled, it is not possible to make a dup3() call that disables
> O_NONBLOCK, which is an odd asymmetry in the API.)

That's why I didn't add support for the flag.  It's hardly useful to
add this support.
