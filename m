Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYIBH61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYIBH61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 03:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYIBH6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 03:58:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:60875 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYIBH6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 03:58:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=ejh1sTfRXiuVjrp8FZ73vQA9zAzl254TrpCnUVB/IdJtuw+2DDByMaMGjZ3BPB6bPo
         2MgqUWVqICUhRBCQVOMVXR16o3UqjeJgn83oDs00c3mJocczJLdhOLtjBVdiEswTwveO
         6v/IYCSieG97HxV5JKeZUmHQpWZCULKE8RxcM=
Message-ID: <48BCF211.3050809@gmail.com>
Date: Tue, 02 Sep 2008 09:58:09 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Rationale for paccept() sigset argument?
References: <48AC4B44.2010606@gmail.com> <a36005b50809011748j75b1984ar844252a57f7e1d50@mail.gmail.com>
In-Reply-To: <a36005b50809011748j75b1984ar844252a57f7e1d50@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On Wed, Aug 20, 2008 at 9:50 AM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
>> What is the rationale for the sigset argument of paccept()?
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

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
