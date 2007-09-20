Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbXITIDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbXITIDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXITICz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:02:55 -0400
Received: from web53708.mail.re2.yahoo.com ([206.190.37.29]:37041 "HELO
	web53708.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751567AbXITICx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:02:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ApYBn7GB7uMixhIHMsqQBUI2HEEGz/nv09votgZuo8VursKbdBOEzNQFVPbTEcKEpMPpIVyia3QV5bs10gPO2NpVDUy+DCCkFyMKTs4O+LoWIpO42T9CvoohIh/dsEZrobVVjWHJBeUWZPErZmGxy1QZOL3Un8BiGWsbfyOs+f8=;
X-YMail-OSG: 0kqcK_cVM1kwpjrVO43TG5gltZ5_QuM4sQ8ThxCBVxJppYjEqVDe..k69K1rcVQAoIepjLLwTLMF7UlOzWFjP.ECY.ZBs.1YRZcBn9YU7DO2YDXjX2c-
Date: Thu, 20 Sep 2007 01:02:51 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT events get missed for TCP sockets
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46F20F24.1020900@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <712722.8047.qm@web53708.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Eric Dumazet <dada1@cosmosbay.com> wrote:

> Nagendra Tomar a écrit :
> > --- Davide Libenzi <davidel@xmailserver.org> wrote:
> > 
> >> On Wed, 19 Sep 2007, David Miller wrote:
> >>
> >>> From: Nagendra Tomar <tomer_iisc@yahoo.com>
> >>> Date: Wed, 19 Sep 2007 15:37:09 -0700 (PDT)
> >>>
> >>>> With the SOCK_NOSPACE check in tcp_check_space(), this epoll_wait call will 
> >>>> not return, even when the incoming acks free the buffers.
> >>>>         Note that this patch assumes that the SOCK_NOSPACE check in
> >>>> tcp_check_space is a trivial optimization which can be safely removed.
> >>> I already replied to your patch posting explaining that whatever is
> >>> not setting SOCK_NOSPACE should be fixed instead.
> >>>
> >>> Please address that, thanks.
> >> You're not planning of putting the notion of a SOCK_NOSPACE bit inside a 
> >> completely device-unaware interface like epoll, I hope?
> >>
> > 
> > Definitely not ! 
> > 
> > The point is that the "tcp write space available" 
> > wakeup does not get called if SOCK_NOSPACE bit is not set. This was
> > fine when the wakeup was merely a wakeup (since SOCK_NOSPACE bit 
> > indicated that someone really cared abt the wakeup). Now after the
> > introduction of callback'ed wakeups, we might have some work to
> > do inside the callback even if there is nobody interested in the wakeup
> > at that point of time. 
> > 
> > In this particular case the ep_poll_callback is not getting called and
> > hence the socket fd is not getting added to the ready list.
> > 
> 
> Does it means that with your patch each ACK on a ET managed socket will 
> trigger an epoll event   ?
> 
> Maybe your very sensitive high throuput appication needs to set a flag or 
> something at socket level to ask for such a behavior.
> 
> The default should stay as is. That is an event should be sent only if someone 
> cared about the wakeup.
> 

A high throughput app will always care about the wakeup, or else it will 
not be a high throughput app in the first place. An application that
occasionaly writes and then goes to slumber and then writes again will
not be a high throughput app. 
    
My point is that the SOCK_NOSPACE check does not save us much. For
high throughput app it will almost always be set, thus making the 
check insignificant, and for the low throughput case we care less.

Thanx,
Tomar



      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/ 
