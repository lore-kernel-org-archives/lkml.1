Return-Path: <linux-kernel-owner+w=401wt.eu-S1765753AbYCFLGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765753AbYCFLGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYCFLGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:06:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbYCFLGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:06:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/2] send_sigqueue: don't forget about handle_stop_signal()
In-Reply-To: Oleg Nesterov's message of  Thursday, 6 March 2008 00:53:14 +0300 <20080305215314.GA3821@tv-sign.ru>
References: <20080305215314.GA3821@tv-sign.ru>
Emacs: don't try this at home, kids!
Message-Id: <20080306110608.4C0F52700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 03:06:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> send_group_sigqueue() calls handle_stop_signal(), send_sigqueue() doesn't.
> This is not consistent and in fact I'd say this is (minor) bug.

Yes, it was wrong.  I think I noticed it long ago and never bothered with
it because send_sigqueue is nearly unused.  SIGEV_THREAD_ID is in practice
only used internally by libc (timer_create) to implement SIGEV_THREAD, and
it never uses any of the signals handle_stop_signal checks for.

Your fix is good and should go in.
I'd bet noone will ever notice the difference now or ever.


Thanks,
Roland
