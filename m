Return-Path: <linux-kernel-owner+w=401wt.eu-S1422832AbXDXRf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422832AbXDXRf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422829AbXDXRf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:35:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41140 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422823AbXDXRfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:35:54 -0400
Date: Tue, 24 Apr 2007 12:35:42 -0500
To: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linux-s390@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
Message-ID: <20070424173542.GY31947@austin.ibm.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769695763104-git-send-email-ebiederm@xmission.com> <20070422123155.GF20763@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070422123155.GF20763@infradead.org>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 01:58:45AM -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> This patch modifies the startup of eehd to use kthread_run
> not a combination of kernel_thread and daemonize.  Making
> the code slightly simpler and more maintainable.

For the patch that touched arch/powerpc/platforms/pseries/eeh_event.c,
I ran a variety of tests, and couldn't see/find/evoke any adverse
effects, so ..

Acked-by: Linas Vepstas <linas@austin.ibm.com>

> The second question is whether this is the right implementation.
> kthread_create already works by using a workqueue to create the thread
> and then waits for it.  If we really want to support creating threads
> asynchronously on demand we should have a proper API in kthread.c for
> this instead of spreading workqueues.

Yes, exactly; all I really want is to start a thread from an
interrupt context, and pass a structure to it.  This is pretty much
all that arch/powerpc/platforms/pseries/eeh_event.c is trying to do,
and little else.

--linas

