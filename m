Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbZD2P6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbZD2P6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758419AbZD2P6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:58:05 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47455 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbZD2P6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:58:03 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 29 Apr 2009 08:53:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Ingo Molnar <mingo@elte.hu>, linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       cl@linux.com, jesse.brandeburg@intel.com, netdev@vger.kernel.org,
       haoki@redhat.com, mchan@broadcom.com
Subject: Re: [PATCH] poll: Avoid extra wakeups in select/poll
In-Reply-To: <49F84833.5000908@cosmosbay.com>
Message-ID: <alpine.DEB.1.10.0904290850210.25124@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0904241554100.29995@qirst.com> <49F3308B.1030507@cosmosbay.com> <20090426.020411.157511269.davem@davemloft.net> <49F43B8F.2050907@cosmosbay.com> <87ab60rh8t.fsf@basil.nowhere.org> <49F71B63.8010503@cosmosbay.com>
 <20090429091637.GA29874@elte.hu> <49F81FB9.50504@cosmosbay.com> <20090429102734.GC2373@elte.hu> <49F84833.5000908@cosmosbay.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Eric Dumazet wrote:

> [PATCH] poll: Avoid extra wakeups in select/poll
> 
> After introduction of keyed wakeups Davide Libenzi did on epoll, we
> are able to avoid spurious wakeups in poll()/select() code too.
> 
> For example, typical use of poll()/select() is to wait for incoming
> network frames on many sockets. But TX completion for UDP/TCP 
> frames call sock_wfree() which in turn schedules thread.
> 
> When scheduled, thread does a full scan of all polled fds and
> can sleep again, because nothing is really available. If number
> of fds is large, this cause significant load.
> 
> This patch makes select()/poll() aware of keyed wakeups and
> useless wakeups are avoided. This reduces number of context
> switches by about 50% on some setups, and work performed
> by sofirq handlers.

Looks fine to me Eric ...

Acked-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


