Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbXK0PI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbXK0PI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbXK0PIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:08:18 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43654 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbXK0PIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:08:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/3] start the global /sbin/init with 0,0 special pids
References: <20071127135948.GA8370@tv-sign.ru>
Date: Tue, 27 Nov 2007 08:06:58 -0700
In-Reply-To: <20071127135948.GA8370@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 27 Nov 2007 16:59:48 +0300")
Message-ID: <m1bq9fk9rh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> As Eric pointed out, there is no problem with init starting with sid == pgid
> == 0, and this was historical linux behavior changed in 2.6.18.
>
> Remove kernel_init()->__set_special_pids().
>
> This change and the previous change in daemonize() mean that /sbin/init does
> not need the special "session != 1" hack in sys_setsid() any longer. We can't
> remove this check yet, we should cleanup copy_process(CLONE_NEWPID) first, so
> update the comment only.

I guess that works.  As long as we get there.  We just need one more patch
in this series to fix the copy_process(CLONE_NEWPID).

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>


