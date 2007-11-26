Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbXKZS6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbXKZS6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXKZS6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:58:44 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34980 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbXKZS6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:58:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH? 3/3] move daemonized kernel threads into the swapper's session
References: <20071126142556.GA16531@tv-sign.ru>
Date: Mon, 26 Nov 2007 11:57:36 -0700
In-Reply-To: <20071126142556.GA16531@tv-sign.ru> (Oleg Nesterov's message of
	"Mon, 26 Nov 2007 17:25:56 +0300")
Message-ID: <m14pf8omvz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> Any reason why daemonized kthread still uses 1,1 special pids? This patch
> sets 0,0 pids, this matches kthread_create'ed threads.

You got it in your reply...

> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>



Hmm.  I wonder if we could ensure kernel_thread always
returns a global pid_t, and then reallocate the struct
pid for the task we have just daemonized so that it only
has a single pid in the init_pid_ns.

That would remove our capturing of child pid namespaces.

Eric
