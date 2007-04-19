Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbXDSWfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbXDSWfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXDSWfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:35:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbXDSWfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:35:38 -0400
Date: Thu, 19 Apr 2007 15:34:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] dvb_en_50221: Convert to kthread API
Message-Id: <20070419153413.8768fd1d.akpm@linux-foundation.org>
In-Reply-To: <1176969639190-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<1176969639190-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:59:04 -0600
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> This patch is a minimal transformation to use the kthread API
> doing it's best to preserve the existing logic.
> 
> Instead of starting kdvb-ca by calling kernel_thread,
> daemonize and sigfillset we kthread_run is used.
> 
> Instead of tracking the pid of the running thread we instead
> simply keep a flag to indicate that the current thread is
> running, as that is all the pid is really used for.
> 
> And finally the kill_proc sending signal 0 to the kernel thread to
> ensure it is alive before we wait for it to shutdown is removed.
> The kthread API does not provide the pid so we don't have that
> information readily available and the test is just silly.  If there
> is no shutdown race the test is a useless confirmation of that the
> thread is running.  If there is a race the test doesn't fix it and
> we should fix the race properly.

urgh, yes, this is just sad.  We should convert this driver fully to
the kthread API - it will end up much better.

I'll queue this up as a -mm-only thing as a gentle reminder that
we should do it properly.
