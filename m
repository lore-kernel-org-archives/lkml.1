Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbXBJVuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbXBJVuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 16:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbXBJVuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 16:50:19 -0500
Received: from mail.screens.ru ([213.234.233.54]:60883 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbXBJVuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 16:50:18 -0500
Date: Sun, 11 Feb 2007 00:50:14 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] delayed_work tweaks
Message-ID: <20070210215014.GA2210@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, unless you stop me right now, I am going to send the following
patches in addition:

	[PATCH] kill cancel_rearming_delayed_workqueue()

		cancel_rearming_delayed_workqueue(wq, dwork) does not
		need the first parameter, it could be figured out from
		dwork. So we can rename it to cancel_rearming_delayed_work
		after the simple change and fix all callers.

		In other words:

			- cancel_rearming_delayed_work(dwork) will work
			  for any workqueue, not just keventd_wq.

			- all callers of cancel_rearming_delayed_workqueue()
			  will be converted to use it.

		No? This breaks the public interface, but we already did
		this recently ...

	[PATCH] kill flush_work_keventd()

		The same is true for flush_work(), it doesn't need the
		"struct workqueue_struct *wq" parameter. I missed this
		fact when I was doing flush_work().

		This change is obviously good to do before flush_work()
		goes to mainline.

		Also, I think the name "flush_work" is very bad. Isn't
		it better to rename it as well?

		cancel_work? cancel_work_sync? whatever.

	[PATCH] bonus: mark kernel/workqueue.c as CONFIG_EXPERIMENTAL

		too many non-reviewed changes ...

Oleg.

