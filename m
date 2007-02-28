Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXB1TXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXB1TXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbXB1TXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:23:41 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4828 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbXB1TXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:23:40 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Feb 2007 11:23:37 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch - v3] epoll ready set loops diet ...
In-Reply-To: <200702282009.29527.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0702281115090.6806@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702281034050.6806@alien.or.mcafeemobile.com>
 <200702282009.29527.dada1@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Eric Dumazet wrote:

> On Wednesday 28 February 2007 19:37, Davide Libenzi wrote:
> 
> > +		list_del(&epi->rdllink);
> > +		if (!(epi->event.events & EPOLLET) && (revents & epi->event.events))
> > +			list_add_tail(&epi->rdllink, &injlist);
> > +		else {
> 
> Is the ( ... & epi->event.events) really necessary ? (It seems already done)

Yes, look here:

	if (epi->event.events & EPOLLONESHOT)
                 epi->event.events &= EP_PRIVATE_BITS;

Oneshot events should not be requeued.


> I was wrong about the size of epitem : it is now 68 bytes instead of 72.
> At least we now use/dirty one cache line instead of two per epitem.
> 
> Do you have another brilliant idea to shrink 4 more bytes ? :)

I don't think we can cleanly shove more stuff out of it.



- Davide


