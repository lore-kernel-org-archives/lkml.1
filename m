Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbXISXub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbXISXub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbXISXuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:50:19 -0400
Received: from web53704.mail.re2.yahoo.com ([206.190.37.25]:36625 "HELO
	web53704.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750968AbXISXuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:50:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=pTBLMITciTcYLwXhiYZkPjwTFAYN+R2jqpn5BEPTGQwNoOLEb8skmyJl9rT2RpooYDLoyUrCq8Hc3bV1U1A7FAbkE6Y+Mesl9hBswf/SCMa4MnWKRZn5q2AeDi6Py+tuPyQkcMM8gbOH2HY6wpJCQNSYUtrh7tqjzaF+xpuOCMc=;
X-YMail-OSG: 689X5T0VM1mR.Vt3PLJPk0LwWjpGWWgGlG5Qk_rjqwgdsh.ntkwK1.GziI_wIGBqQwazCwdUa9Sq16S8x0sGoC8NEb241yZDthThm5gamd.MXMQ-
Date: Wed, 19 Sep 2007 16:50:17 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT events get missed for TCP sockets
To: Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>
Cc: tomer_iisc@yahoo.com, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709191552171.2989@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <331107.71046.qm@web53704.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Davide Libenzi <davidel@xmailserver.org> wrote:

> On Wed, 19 Sep 2007, David Miller wrote:
> 
> > From: Nagendra Tomar <tomer_iisc@yahoo.com>
> > Date: Wed, 19 Sep 2007 15:37:09 -0700 (PDT)
> > 
> > > With the SOCK_NOSPACE check in tcp_check_space(), this epoll_wait call will 
> > > not return, even when the incoming acks free the buffers.
> > >         Note that this patch assumes that the SOCK_NOSPACE check in
> > > tcp_check_space is a trivial optimization which can be safely removed.
> > 
> > I already replied to your patch posting explaining that whatever is
> > not setting SOCK_NOSPACE should be fixed instead.
> > 
> > Please address that, thanks.
> 
> You're not planning of putting the notion of a SOCK_NOSPACE bit inside a 
> completely device-unaware interface like epoll, I hope?
> 

Definitely not ! 

The point is that the "tcp write space available" 
wakeup does not get called if SOCK_NOSPACE bit is not set. This was
fine when the wakeup was merely a wakeup (since SOCK_NOSPACE bit 
indicated that someone really cared abt the wakeup). Now after the
introduction of callback'ed wakeups, we might have some work to
do inside the callback even if there is nobody interested in the wakeup
at that point of time. 

In this particular case the ep_poll_callback is not getting called and
hence the socket fd is not getting added to the ready list.

Thanx,
Tomar




      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/
