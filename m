Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbYIBFGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbYIBFGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 01:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYIBFGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 01:06:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:29019 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYIBFGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 01:06:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=h25SAlSL9CVIAaZn66mS65CSLNapsGaRwFN9lFskwjMSrK5OOvk0yOqkxjPb2OYVxY
         cc4xH1jcnYXWYJRmb3GfAXWnx5pA7sO12TG41n2UoYbW5cj3QHETVr5bJMxNdjuIfrxX
         xzCq53Y3sMvIDgp6LnFIduVr63K/3KMJNv9JY=
Message-ID: <cfd18e0f0809012206i4e39bbaeg6b6788325b664087@mail.gmail.com>
Date: Mon, 1 Sep 2008 22:06:06 -0700
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Ulrich Drepper" <drepper@gmail.com>
Subject: Re: No NONBLOCK flag for dup3() or epoll_create1()?
Cc: "Ulrich Drepper" <drepper@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       "Davide Libenzi" <davidel@xmailserver.org>
In-Reply-To: <a36005b50809011734w73f48dc1l68853e4e73309c2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AC4B19.6000206@gmail.com>
	 <a36005b50809011734w73f48dc1l68853e4e73309c2a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2008 at 5:34 PM, Ulrich Drepper <drepper@gmail.com> wrote:
> On Wed, Aug 20, 2008 at 9:49 AM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
>> I've been doing some testing (2.6.27-rc3) of your new
>> file-descriptor-creating syscalls that accept flags.  According to
>>
>> http://udrepper.livejournal.com/20407.html
>>
>> all of the system calls should accept a *_NONBLOCK flag.
>
> This was never the intention.

All of the below makes some sense, but is at odds with what you posted
on your blog entry, which documents *_NONBLOCK for both
epoll_create1() and dup3().  Thus, I needed to check with you since
the "intention" stated in the blog post differs from the actual
implementation.

>> For epoll_create1() this certainly appears to be an oversight, since I can't
>> think of a reason not to support *_NONBLOCK.
>
> I can.  There is already a method to not block (zero timeout).  We
> should not provide multiple ways to get the same functionality.

Though, one reason to do so would be consistency with the other
changed APIs.  (There are many cases where *ix API provides more than
one way of getting the same functionality.)

> It
> would require changes in the epoll code as well.  That's not worth it.
>
>
>>  (Furthermore, given a open file description for which O_NONBLOCK is
>> already enabled, it is not possible to make a dup3() call that disables
>> O_NONBLOCK, which is an odd asymmetry in the API.)
>
> That's why I didn't add support for the flag.  It's hardly useful to
> add this support.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
