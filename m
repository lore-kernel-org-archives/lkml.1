Return-Path: <linux-kernel-owner+w=401wt.eu-S1750919AbXBMUJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919AbXBMUJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXBMUJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:09:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43767 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXBMUJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:09:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@openvz.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: Alt+SysRq+K broken
References: <20070213144814.GA6017@localhost.sw.ru>
Date: Tue, 13 Feb 2007 13:08:52 -0700
In-Reply-To: <20070213144814.GA6017@localhost.sw.ru> (Alexey Dobriyan's
	message of "Tue, 13 Feb 2007 17:48:14 +0300")
Message-ID: <m1lkj1stuz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@openvz.org> writes:

> kernel BUG at kernel/workqueue.c:212! 100% reproducable
>
> 	queue_work
> 	__handle_sysrq
> 	kbd_event
> 	add_timer_randomness
> 	kbd_event
> 	input_event
> 	atkbd_interrupt
> 	serio_interrupt
> 	i8042_interrupt
> 		...
>
> reverting the following patch make it work again.

Thanks,

I wrote the patch just before the big set of work queue changes,
and had to fix it to work with the new style of work queues when
it went it Andrews tree.  It looks like the work queue api
continued to change and my patch bit rotted.

I will take a look and see what it takes to updated the code to
the current API.

I'm pretty certain a s/PREPARE_WORK/INIT_WORK/g would make it
work but I'm not certain that is correct.

Eric
