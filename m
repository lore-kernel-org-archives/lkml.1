Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbXFNTgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbXFNTgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXFNTgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:36:42 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:48197 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751063AbXFNTgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:36:42 -0400
Message-ID: <467198C8.1040107@steeleye.com>
Date: Thu, 14 Jun 2007 15:36:40 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nbd.c:sock_xmit: cleanup signal related code
References: <20070614172243.GA2446@tv-sign.ru>
In-Reply-To: <20070614172243.GA2446@tv-sign.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> sock_xmit() re-implements sigprocmask() and dequeue_signal_lock().

Yeah, that code was written before those existed. Thanks for the clean up.

> Note: I can't understand this dequeue_signal(), it can dequeue SIGKILL
> for the user-space task doing nbd_ioctl() ?

So we can interrupt an nbd transmission without waiting for a TCP 
timeout (when we know the network is down).

> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Patch looks good to me.

--
Paul
