Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZEDTLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZEDTLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbZEDTK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:10:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbZEDTK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:10:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace: do not use task_lock() for attach
In-Reply-To: Oleg Nesterov's message of  Sunday, 3 May 2009 20:55:49 +0200 <20090503185549.GA17087@redhat.com>
References: <20090503185549.GA17087@redhat.com>
Emacs: don't cry -- it won't help.
Message-Id: <20090504190935.A0FD4FC32F@magilla.sf.frob.com>
Date: Mon,  4 May 2009 12:09:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks good to me overall.  It might be worth slicing it into two or
more patches, just for bisect paranoia.  (e.g. PF_KTHREAD; task_lock in
ptrace_attach; task_lock in ptrace_traceme.)

I think it merits a comment that the PF_KTHREAD check does not need any
interlock because daemonize() will detach ptrace via reparent_to_kthreadd()
after it sets PF_KTHREAD.  (vs the old ->mm check under task_lock.)

It is worth noting that this changes the security_ptrace_traceme() call so
it's no longer under task_lock().  I can't see any way the LSM hooks care,
but it is a change.

You also didn't mention the s/|=/=/ changes.  Those are correct, we've
already agreed, but the commit log should mention that this subtle change
was intentional.


Thanks,
Roland
