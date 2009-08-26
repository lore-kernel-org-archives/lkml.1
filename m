Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbZHZPEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbZHZPEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZHZPEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:04:33 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:38580 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZHZPEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:04:32 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 26 Aug 2009 08:04:32 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Will Brown <dr.hfuhruhurr@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Epoll frequently fails to notify connects at connect 
 bursts
In-Reply-To: <8a1bd2320908260215w23d1f426x33f90e38ccc3fe2c@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0908260802520.6557@makko.or.mcafeemobile.com>
References: <8a1bd2320908251748u324ae5e6g7015069180253db3@mail.gmail.com>  <alpine.DEB.2.00.0908251812450.18518@makko.or.mcafeemobile.com>  <alpine.DEB.2.00.0908251823470.18518@makko.or.mcafeemobile.com>
 <8a1bd2320908260215w23d1f426x33f90e38ccc3fe2c@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1623378626-1251299073=:6557"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1623378626-1251299073=:6557
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 26 Aug 2009, Will Brown wrote:

> On Wed, Aug 26, 2009 at 3:24 AM, Davide Libenzi<davidel@xmailserver.org> wrote:
> > On Tue, 25 Aug 2009, Davide Libenzi wrote:
> >
> >> Multiple quasi-simultaneous events for the same fd are merged. This is why
> >> on POLLIN on accepting sockets you want to do something like:
> >>
> >>       while ((afd = accept(sfd, ...)) != -1)
> >>               add_client(afd);
> >
> > Of course, with  sfd  in non-blocking mode. Alternatively, you drop EPOLLET
> > for the  sfd  socket.
> >
> 
> Aha! Thank you immensely Davide. It cost me one week of frustration already.
> 
> 1. Where should I have picked up this gem of essential information? I
> haven't seen it in the man-pages for either 'epoll' or 'accept'.
> 
> 2. Is it better to use a level-triggered listener socket, or to use
> the accept-loop?

EPOLLET can be more efficent, but it can also be a little more trickier to 
grasp. LT mode maps more closely to poll/select, that makes it more 
familiar to users.


- Davide


--8323329-1623378626-1251299073=:6557--
