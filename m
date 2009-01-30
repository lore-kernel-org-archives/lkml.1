Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZA3HmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZA3HmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 02:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZA3Hl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 02:41:56 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44688 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZA3Hl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 02:41:56 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 29 Jan 2009 23:41:53 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] epoll fix own poll()
In-Reply-To: <200901300329.35641.pisa@cmp.felk.cvut.cz>
Message-ID: <alpine.DEB.1.10.0901292339480.16141@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com> <alpine.DEB.1.10.0901291030390.15448@alien.or.mcafeemobile.com> <20090129103715.2d3a8274.akpm@linux-foundation.org> <200901300329.35641.pisa@cmp.felk.cvut.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Pavel Pisa wrote:

> epoll_wait() unconditionally calls  ep_poll(), the "rdllist" is not empty
> (cheked by previous ep_eventpoll_poll() call), so ep_send_events()
> has to be called. It moves all events from "rdllist" onto  "txlist"
> and reports events confirmed by individual poll() calls to user.
> There could be non signaling events in the "rdlist" left there from
> previous scan for level triggering events or in case, that condition
> is reset by some other intervention before  ep_eventpoll_poll().
> All this is not problem yet, it would result in one abundant call to
> epoll_wait() which returns 0. No problem. The EPOLLET events
> are moved from "rdlist", others (level triggered events) signalling
> are queued on "rdlist" again. If userspace does its duty, they would
> be removed during next call. This all seems to suggests, that one
> abundant epoll_wait() would get things back on the right path.
> All critical processing (moving between lists) seems to be under
> held of spinlock, so possibility for bugs is low. I have not yet analyzed
> overflow list which complicates things.
> 
> I am not clever enough, to see, where is the problem, that situation
> is not stabilized. Can you teach me Davide, please?

Sorry, I missed part of the email. Yes, if revents is zero in the 
send-lood, I don't see how files can be added back to the ready-list.
Please, create a very small test program that exhibit such behaviour ...



- Davide


