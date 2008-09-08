Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYIHNd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYIHNd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYIHNds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:33:48 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:39644 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYIHNdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=CqMjKSkNify+3afftesvvIG4WJhRBDGS7VVV1B4VCLV2AxNRWQoP6ZuioRqNX22l38
         hP8IOA4DzaOrVEDT1IzIDuenT34NFDEAFcPUsoF7wTWeqHnGmReVn3MsO0d4/ERUTLVr
         mrEVZOWbissnqxyB7YbqPbV5TLzC0pM0ZZ6Xk=
Message-ID: <cfd18e0f0809080633k3989f514k69dae13063db137b@mail.gmail.com>
Date: Mon, 8 Sep 2008 15:33:46 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: Rationale for paccept() sigset argument?
Cc: "Michael Kerrisk" <mtk.manpages@googlemail.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jakub Jelinek" <jakub@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <48BCF211.3050809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AC4B44.2010606@gmail.com>
	 <a36005b50809011748j75b1984ar844252a57f7e1d50@mail.gmail.com>
	 <48BCF211.3050809@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich -- ping!

---------- Forwarded message ----------
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Sep 2, 2008 9:58 AM
Subject: Re: Rationale for paccept() sigset argument?
To: Ulrich Drepper <drepper@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>, Ulrich Drepper
<drepper@redhat.com>, Davide Libenzi <davidel@xmailserver.org>, lkml
<linux-kernel@vger.kernel.org>, Andrew Morton
<akpm@linux-foundation.org>, Jakub Jelinek <jakub@redhat.com>, Linus
Torvalds <torvalds@linux-foundation.org>


Ulrich Drepper wrote:
> On Wed, Aug 20, 2008 at 9:50 AM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
>
> > What is the rationale for the sigset argument of paccept()?
> >
>
> accept, like select/poll, is used often as a function to dealy
> operation.  Unlike read, recv, etc, which are handled using O_NONBLOCK
> and select/poll.  pselect/ppoll do not really have a sigset parameter
> to handle signals in general.  You use it to enable special handling
> in case of blocking.  Example: if you want to implement userlevel
> context switching, you dedicate a signal to wake up any blocked
> thread.  Since accept falls more into the same category than poll,
> this means the sigset parameter is justified.  In theory we could add
> it to all functions but there is no reason to do this without any
> other reason to change the interface.
>


Ulrich, you snipped a relevant piece of my earlier message:

[[
> * It seems to me that any case where we might want to use paccept() could be
> equivalently dealt with using the existing pselect()/ppoll()/epoll_pwait()
> followed by a conventional accept() if the listening file descriptor
> indicates as ready.
]]

So I'll rephrase: what use case does the sigset argument of paccept()
allow us to handle that couldn't equally have been handled by
pselect()/ppoll()/epoll_pwait() + traditional accept()?


Cheers,

Michael
