Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbXDFIna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbXDFIna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 04:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXDFIna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 04:43:30 -0400
Received: from mail.screens.ru ([213.234.233.54]:51364 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXDFIn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 04:43:29 -0400
Date: Fri, 6 Apr 2007 12:42:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Robin Holt <holt@sgi.com>
Cc: Chris Snook <csnook@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406084250.GA179@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
>
> wait_task_zombie() is taking many seconds to get through the list.
> For the case of a modprobe, stop_machine creates one thread per cpu
> (remember big number). All are parented to init and their exit will
> cause wait_task_zombie to scan multiple times most of the way through
> this very long list looking for threads which need to be reaped.

Could you try this patch

	http://marc.info/?l=linux-kernel&m=117337194209912

?

It can't solve the whole problem, but at least an exiting kernel thread
won't kick init.

Oleg.

