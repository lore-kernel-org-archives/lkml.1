Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbXDSXrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbXDSXrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbXDSXrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:47:47 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754320AbXDSXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:47:46 -0400
Date: Thu, 19 Apr 2007 16:47:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
Message-Id: <20070419164723.dd55a6f3.akpm@linux-foundation.org>
In-Reply-To: <11769695763104-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769695763104-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:58:45 -0600
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> This patch modifies the startup of eehd to use kthread_run
> not a combination of kernel_thread and daemonize.  Making
> the code slightly simpler and more maintainable.
> 

You're making me look at a lot of things which I'd prefer not to have
looked at.

>  arch/powerpc/platforms/pseries/eeh_event.c |    4 ++--

This one kicks off a kernel thread in response to each "PCI error event",
and that kernel thread hangs about for one hour then exits.

One wonders what happens if we get 1,000,000 of these events per
second.

