Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYJJFBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYJJFBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYJJFBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:01:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:47166 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYJJFBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=ROMQQrNj1lzhT7XN0MunG4/QfFqc6wxANXwO1KRM498834bCiVMHGxb8UVwZHaJE/2
         y6oWW9JFzXDokAGwHQQWWF/1a8yxDhBf+g1cITh6cEuC0A66d0Ws4KJrsFFlbQOJ4p0P
         9/NZ1q6SZK7cvYXMu5E9oONNwrDjvWxe8X4G8=
Message-ID: <cfd18e0f0810092201s36eea70fr51da29c901157baa@mail.gmail.com>
Date: Fri, 10 Oct 2008 07:01:06 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: dup2() vs dup3() inconsistency when
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Al Viro" <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48EE6A2B.8030005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com>
	 <48EE3D84.6000003@zytor.com> <48EE6A2B.8030005@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 10:31 PM, Ulrich Drepper <drepper@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> H. Peter Anvin wrote:
>> The dup2() behavior comes from the logical consequence of dup2()'s
>> "close on reuse"; one would think it would be logical for dup3() to
>> behave the same way.
>
> No.  We deliberately decided on this change.  Otherwise, what is the
> result of dup3(fd, fd, O_CLOEXEC)?

Good point.  However, I don't find any list mail that discussed this
implementation choice or its rationale.  That would have been useful.

> There is no reason to use
> dup2(fd,fd), so why the hell somebody wants to defend this is beyond me.

There is no defense, except consistency with historical behavior.  My
reasons for raising this thread were:

a) to point out the inconsistency with dup2().
b) to check that the change was intentional (though it was already
fairly clear that it was)
c) to determine the reason(s) for the change (which were not made clear)

As you point out, we have various possibilities with dup3(fd, fd, flags)

1) Do nothing to fd.
2) change the O_CLOEXEC flag for fd.
3) Give an error.

The problem is that depending on one's perspective one argue that
either 1 or 2 is consistent with dup2(), so 3 seems a reasonable thing
to do.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
