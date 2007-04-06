Return-Path: <linux-kernel-owner+w=401wt.eu-S1767546AbXDFJLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767546AbXDFJLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 05:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766609AbXDFJLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 05:11:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42398 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767546AbXDFJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 05:11:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Robin Holt <holt@sgi.com>, Chris Snook <csnook@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
References: <20070406084250.GA179@tv-sign.ru>
Date: Fri, 06 Apr 2007 03:10:29 -0600
In-Reply-To: <20070406084250.GA179@tv-sign.ru> (Oleg Nesterov's message of
	"Fri, 6 Apr 2007 12:42:50 +0400")
Message-ID: <m18xd5amwq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> Robin Holt wrote:
>>
>> wait_task_zombie() is taking many seconds to get through the list.
>> For the case of a modprobe, stop_machine creates one thread per cpu
>> (remember big number). All are parented to init and their exit will
>> cause wait_task_zombie to scan multiple times most of the way through
>> this very long list looking for threads which need to be reaped.
>
> Could you try this patch
>
> 	http://marc.info/?l=linux-kernel&m=117337194209912
>
> ?
>
> It can't solve the whole problem, but at least an exiting kernel thread
> won't kick init.

At first glance your patch looks reasonable.

Unfortunately it only applies to the rare thread that calls daemonize,
and not also to kernel/kthread/kthread() which means it will miss many of
our current kernel threads.

For the sgi problem I doubt it is will make a difference but the change
is certainly worth making.

Eric
