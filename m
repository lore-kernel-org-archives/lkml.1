Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbXKZWsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbXKZWsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbXKZWrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:47:55 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42094 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694AbXKZWrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:47:55 -0500
Date: Tue, 27 Nov 2007 01:46:49 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] fix setsid() for sub-namespace /sbin/init
Message-ID: <20071126224649.GA393@tv-sign.ru>
References: <20071126142553.GA16525@tv-sign.ru> <m1zlx0n7ga.fsf@ebiederm.dsl.xmission.com> <20071126201139.GA84@tv-sign.ru> <m1r6icn0s9.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6icn0s9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > This is different, perhaps we can keep this call. kernel_thread(kernel_init)
> > attaches /sbin/init to init_struct_pid. Nothing bad, and a "good" init should
> > do setsid() anyway. But who knows? Some special environment may expect that
> > getpgrp() != 0. Not that I really disagree on this issue though.
> 
> init starting with session == pgrp == 0 is historical linux behavior.  I consider
> the current 2.6 behavior a temporary aberation from the historical linux behavior.

Ah, OK.

> Plus once we do this the code will be easier to maintain because we have
> removed one obscure special case.

Yes indeed. So we can remove this special case code as soon as copy_process()
is changed.

Oleg.

