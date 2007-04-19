Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbXDSXZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbXDSXZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXDSXZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:25:25 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172AbXDSXZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:25:25 -0400
Date: Thu, 19 Apr 2007 16:24:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] bluetooth bnep: Convert to kthread API.
Message-Id: <20070419162459.af7a182c.akpm@linux-foundation.org>
In-Reply-To: <1176969596686-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<1176969596686-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:58:51 -0600
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> This patch starts kbenpd using kthread_run replacing
> a combination of kernel_thread and daemonize.  Making
> the code a little simpler and more maintainable.
> 
>

	while (!atomic_read(&s->killed)) {

ho hum.

> +	task = kthread_run(bnep_session, s, "kbnepd %s", dev->name);

It's unusual to have a kernel thread which has a space in its name.  That
could trip up infufficient-defensive userspace tools.

