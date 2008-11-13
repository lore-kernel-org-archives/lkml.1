Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYKMWCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYKMWCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYKMWCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:02:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:6747 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYKMWC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:02:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=IRfxOYpeEBemdDN5vvYsl2d6E3dgk3B0ChXZGXumPuUUMvCzgdXnxKdastuaPHd144
         Wp5/dqCmYGl7UiK2YlHrunUwzy0qGlEjNP1/usMMU+1ZRz3uGnl8T7Fju2fALxVKybD0
         KKaU5Py7EeUHujWxWehFNXB9pPbbGDV6BV5yU=
Message-ID: <cfd18e0f0811131402j7ec6a60cq462916cc9715b9aa@mail.gmail.com>
Date: Thu, 13 Nov 2008 17:02:28 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] reintroduce accept4
Cc: "Subrata Modak" <subrata@linux.vnet.ibm.com>, linux-arch@vger.kernel.org,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, linux-api@vger.kernel.org,
       linux-man@vger.kernel.org, "Davide Libenzi" <davidel@xmailserver.org>,
       netdev <netdev@vger.kernel.org>, "Roland McGrath" <roland@redhat.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Christoph Hellwig" <hch@lst.de>,
       "David Miller" <davem@davemloft.net>, "Alan Cox" <alan@redhat.com>,
       "Jakub Jelinek" <jakub@redhat.com>
In-Reply-To: <517f3f820811131351l1305b2d2u43ab4e0601d97f93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com>
	 <517f3f820811131351l1305b2d2u43ab4e0601d97f93@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hit the send button a little early on my last mail.  Just to complete one piece:

> My only argument is with the name of the new sysytem call.

... Each of these new system calls (accept4(), dup3(), evenfd2(),
signalfd4(), inotify_init1(), epoll_create1(), pipe2()) has a name
that's based on the number of arguments it has.  This follows a
convention that was used in a few traditional Unix system calls, e.g.,
wait3(), wait4(), dup2().  However, it's probably a mistake since:

a) The glibc interfaces can have different numbers of arguments from
the system call

b) In the future, we might use the new bits in the flags argument to
signal the presence of additional arguments for the call, in which
case the number in the name no longer matches the number of arguments
in the call signature.

In the end, names like acceptx(), dupx(), ... or acceptfl(), duplf(),
... or somesuch would probably have been better.  But given that we
already added the other system calls, it doesn't seem worth bothering
to change things for accept4().

Cheers,

Michael
