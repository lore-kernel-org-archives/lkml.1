Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbXDSXab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbXDSXab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbXDSXab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:30:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297AbXDSXaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:30:30 -0400
Date: Thu, 19 Apr 2007 16:30:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] macintosh/mediabay: Convert to kthread API.
Message-Id: <20070419163001.a1928749.akpm@linux-foundation.org>
In-Reply-To: <11769695954018-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769695954018-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:58:50 -0600
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> This patch modifies the startup of the media_bay_task
> to use kthread_run and not a combination of kernel_thread,
> deamonize and sigfillset.
> 
> In addition since we now always want to ignore signals
> the MB_IGNORE_SIGNALS define is removed along with the
> test for signal_pending.
> 
> The result is slightly simpler code that is more
> maintainable.

Looks OK - there's no way of stopping the kernel thread anyway.

It appears that nobody has tried to use this driver at the same time as
software-suspend.  At least, not successfully.  A strategic try_to_freeze()
should fix it.

This will become (a little) more serious when cpu hotplug is switched to
use the process freezer, and perhaps it breaks kprobes already.


