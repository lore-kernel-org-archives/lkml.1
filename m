Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbZD1CkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbZD1CkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZD1CkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:40:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZD1CkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:40:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] copy_process: remove the unneeded
	clear_tsk_thread_flag(TIF_SIGPENDING)
In-Reply-To: Oleg Nesterov's message of  Monday, 27 April 2009 21:48:45 +0200 <20090427194845.GA6245@redhat.com>
References: <20090427194845.GA6245@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090428023919.E2311FC3C6@magilla.sf.frob.com>
Date: Mon, 27 Apr 2009 19:39:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

> The forked child can have TIF_SIGPENDING if it was copied from parent's
> ti->flags. But this is harmless and actually almost never happens, because
> copy_process() can't succeed if signal_pending() == T.

When it does happen, it's actually improper to clear it.  In a CLONE_THREAD
case, the pending signals might include shared_pending signals that the
child too should take.  (Arguably there is no way to notice, since the
parent thread will be racing to dequeue the same signals.)


Thanks,
Roland
