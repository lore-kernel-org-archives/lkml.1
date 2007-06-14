Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbXFNULd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbXFNULd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXFNULZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:11:25 -0400
Received: from mail.screens.ru ([213.234.233.54]:56369 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbXFNULY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:11:24 -0400
Date: Fri, 15 Jun 2007 00:11:32 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Paul Clements <paul.clements@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nbd.c:sock_xmit: cleanup signal related code
Message-ID: <20070614201132.GA278@tv-sign.ru>
References: <20070614172243.GA2446@tv-sign.ru> <467198C8.1040107@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467198C8.1040107@steeleye.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Paul Clements wrote:
>
> Oleg Nesterov wrote:
> 
> >Note: I can't understand this dequeue_signal(), it can dequeue SIGKILL
> >for the user-space task doing nbd_ioctl() ?
> 
> So we can interrupt an nbd transmission without waiting for a TCP 
> timeout (when we know the network is down).

Yes, but that task should not survive after SIGKILL ? Note that SIGNAL_GROUP_EXIT
is set, this is not good.

Oleg.

