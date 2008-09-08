Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbYIHNcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbYIHNcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYIHNb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:31:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:49604 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYIHNb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=GSEJRDTqRwtO+Rsg3ec4qQks9T+hODtIGbJ+/a9ETGWHsprh6fNDQ4O9enhtTaWeLL
         Lq4p/vUTmBlXe+jmAQB0KYu77nW+Kgk8lea82KkActXKpwrthTtAXTrWuNPArmTZxXhV
         sv4iW1GuFS0a76Yo6nhXNsynQhXo1i1xFOJkc=
Message-ID: <cfd18e0f0809080631i456c4754l8bbbe6953e3e841f@mail.gmail.com>
Date: Mon, 8 Sep 2008 15:31:55 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: paccept() oddity
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <cfd18e0f0808291345w2e511ce3oe96a20750f1da5e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AC4B6E.4040409@gmail.com>
	 <cfd18e0f0808291345w2e511ce3oe96a20750f1da5e4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich -- ping!

---------- Forwarded message ----------
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Aug 29, 2008 10:45 PM
Subject: Re: paccept() oddity
To: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Andrew Morton
<akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>,
Linus Torvalds <torvalds@linux-foundation.org>


Ulrich -- Ping!

On Wed, Aug 20, 2008 at 6:50 PM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> Ulrich,
>
> [
> 2.6.27-rc has paccept():
>
> int paccept(int fd, struct sockaddr *sockaddr, socklen_t *addrlen,
>        const sigset_t *sigmask, int setsize, int flags)
> ]
>
> While considering the sigset argument for paccept() (see my previous
> message), and testing that system call, I realized that there is a certain
> oddness in the implementation of paccept().
>
> Like accept(), paccept() automatically restarts if interrupted by a signal
> handler that was established with the SA_RESTART flag.
>
> On the other hand, pselect(), ppoll(), and epoll_pwait() are never restarted
> if interrupted by a handler, even if the handler was established with
> SA_RESTART.  (This is the same as with select(), poll(), and epoll_wait().)
>
> It seems to me that it makes little sense to restart paccept(), especially
> in
> the case where it is interrupted by a handler for one of the signals that is
> in sigmask, since the whole point of calling paccept() is to block until a
> connection is received, or until one of the signals in sigmask is caught().
>
> How about changing paccept() so that it is never automatically restarted if
> interrupted by a signal handler, regardless of the SA_RESTART flag.  (In
> other words, paccept() should be consistent with pselect(), ppoll(), and
> epoll_pwait(), rather than being consistent with accept().)  What are your
> thoughts?
>
> Cheers,
>
> Michael
>
>



--
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
