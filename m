Return-Path: <linux-kernel-owner+w=401wt.eu-S934549AbXEUURp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549AbXEUURp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761472AbXEUURg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:17:36 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2425 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224AbXEUURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:17:35 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 21 May 2007 13:16:40 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: "Davi E. M. Arnaut" <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: + signalfd-retrieve-multiple-signals-with-one-read-call.patch
 added to -mm tree
In-Reply-To: <20070521192551.GA153@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0705211313090.24209@alien.or.mcafeemobile.com>
References: <20070521192551.GA153@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Oleg Nesterov wrote:

> > +		schedule();
> > +		locked = signalfd_lock(ctx, &lk);
> > +		if (unlikely(!locked)) {
> > +			/*
> > +			 * Let the caller read zero byte, ala socket
> > +			 * recv() when the peer disconnect. This test
> > +			 * must be done before doing a dequeue_signal(),
> > +			 * because if the sighand has been orphaned,
> > +			 * the dequeue_signal() call is going to crash.
> > +			 */
> 
> Imho, the comment is a bit confusing. dequeue_signal() needs ->siglock
> even if signalfd_ctx is not orphaned.

The comment looks clear to me. It states:

1) The policy of returning 0 when the sighand has been detached

2) That we _must_not_ call dequeue_signal() in case signalfd_lock() fails

#ACK on the code mod below.



- Davide


