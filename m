Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbYHZTLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbYHZTLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760409AbYHZTLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:11:14 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50470 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760351AbYHZTLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:11:12 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 26 Aug 2008 12:11:05 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Noisternig <mnoist@cosy.sbg.ac.at>
cc: linux-kernel@vger.kernel.org
Subject: Re: (e)poll and (rd)hup questions
In-Reply-To: <48B43C82.8060109@cosy.sbg.ac.at>
Message-ID: <Pine.LNX.4.64.0808261202500.8106@alien.or.mcafeemobile.com>
References: <48B43C82.8060109@cosy.sbg.ac.at>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008, Michael Noisternig wrote:

> Hello folks,
> 
> I hope this is a right place to ask this question. (Sorry if it isn't, please
> hint me where to post in that case.)
> 
> This has been bugging me for quite some while now. I'm using epoll in default
> level-triggered mode. I'm polling for input, output, rdhup, and forcibly for
> hup. I figured that when I get EPOLLRDHUP that doesn't mean there is no more
> data to read, presumably I must empty the kernel buffer by continously reading
> from the fd until I get zero as a result indicating rdhup. This means
> EPOLLRDHUP is delivered asynchronously and thus is pretty useless to me.
> 
> On the other hand, EPOLLHUP seems to be delivered synchronously. If it isn't
> then this means I get constantly notified about a closed fd until I have read
> all data from the kernel buffer and remove the fd from the epoll set (which
> makes being forced to hup notifications useless to me).
> 
> (And no, don't tell me to use edge-triggered mode, I have reasons to use
> level-triggered.)
> 
> Question: Is my observation correct that EPOLLRDHUP is delivered
> asynchronously in contrast to EPOLLHUP? Or is EPOLLHUP delivered
> asynchronously as well?

There's nothing synchronous in epoll WRT userspace. If you use epoll LT, 
you don't need RDHUP. RDHUP was introduced to deal with special 
connection states and epoll ET. Take a peek here for a detailed 
description about how/why RDHUP was introduced:

http://lkml.org/lkml/2003/7/12/116


- Davide


