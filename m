Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYH2Upv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYH2Upv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYH2Upm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:45:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:15408 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYH2Upl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=iNRIIKOQ6it0lS2HQkNg9bjgTSF3HucDdmja6YyFDyZPThTXCg0KS7zV9imuCM9T7u
         /zFY1U/NeC+xJedDd0FzLRZWDXbuJ1Xp/kB8FkiXy80W7Ow7GQkdk0bYA57Cy3YdvuLN
         ImyRZ7Gxosz5oMJrTP5zfN8tynvOyJ9EH1R54=
Message-ID: <cfd18e0f0808291345t5b66fa3dyb48de41095f8425f@mail.gmail.com>
Date: Fri, 29 Aug 2008 22:45:40 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: Rationale for paccept() sigset argument?
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jakub Jelinek" <jakub@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <48AC4B44.2010606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AC4B44.2010606@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich -- Ping!

On Wed, Aug 20, 2008 at 6:50 PM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> Ulrich,
>
> I'll need to cover this point in the man pages, and the rationale still
> isn't
> clear to me, so I'll check it with you...
>
> 2.6.27-rc has paccept():
>
> int paccept(int fd, struct sockaddr *sockaddr, socklen_t *addrlen,
>        const sigset_t *sigmask, int setsize, int flags)
>
> paccept() blocks until either a connection is received on fd, or a signal is
> sigmask() is caught.
>
> What is the rationale for the sigset argument of paccept()?
>
> For pselect()/ppoll()/epoll_pwait(), the sigset argument allows us to deal
> with a not uncommon situation: waiting for both signals and (multiple) file
> descriptors.  (The alternative is the self-pipe trick, which requires more
> programming effort.)
>
> However, do we really need this argument for paccept()?  I ask this for the
> following reasons:
>
> * This seems to be special casing for accept().  But there are other system
> calls (e.g., open(), connect(), recvfrom()) that are similar, in the sense
> that they may wait on a file descriptor, for which there is no [perceived
> need for a] sigset argument.
>
> * It seems to me that any case where we might want to use paccept() could be
> equivalently dealt with using the existing pselect()/ppoll()/epoll_pwait()
> followed by a conventional accept() if the listening file descriptor
> indicates as ready.  (But perhaps I missed something?)
>
> Can you please explain why we need this special case for [p]accept()?
>
> Cheers,
>
> Michael
>
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
> Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
