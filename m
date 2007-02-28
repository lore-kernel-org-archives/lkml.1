Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXB1TJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXB1TJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXB1TJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:09:41 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:45517 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbXB1TJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:09:40 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch - v3] epoll ready set loops diet ...
Date: Wed, 28 Feb 2007 20:09:29 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <Pine.LNX.4.64.0702281034050.6806@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0702281034050.6806@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702282009.29527.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 February 2007 19:37, Davide Libenzi wrote:

> +		list_del(&epi->rdllink);
> +		if (!(epi->event.events & EPOLLET) && (revents & epi->event.events))
> +			list_add_tail(&epi->rdllink, &injlist);
> +		else {

Is the ( ... & epi->event.events) really necessary ? (It seems already done)

I was wrong about the size of epitem : it is now 68 bytes instead of 72.
At least we now use/dirty one cache line instead of two per epitem.

Do you have another brilliant idea to shrink 4 more bytes ? :)

It seems to me 'nwait' is only used at init time (so that 
ep_ptable_queue_proc() can signal an error occured).

Maybe another mechanism could let us delete nwait from epitem ?

We could use a field in task_struct for example (see usage of total_link_count 
for example)

Thank you
