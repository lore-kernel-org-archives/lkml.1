Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbZEFFh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbZEFFh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 01:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZEFFhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 01:37:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44502 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbZEFFhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 01:37:08 -0400
Date: Wed, 6 May 2009 07:33:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [FOR REVIEW, PATCH 0/2] do_wait() cleanups.
Message-ID: <20090506053318.GA31977@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While this is not strictly necessary, I'd like to also cleanup do_wait/etc
before changing ptrace internals. Just because this code is still hardly
readable, imho. And we are going to complicate this code a little bit.

This trivial change nearly killed me. I didn't expect I will spent all
night doing this!!!

The patch is not tested, I am sending it for the early review, because
before I do the next changes I'd like to know your opinion: do you agree
with this patch "in general" ?

If yes, I'll send the next trivial cleanups on top:

	- factor out getrusage() code

	- factor out infop filling

	- simplify retval/notask_error interaction

	- perhaps some small simplifications in do_wait's callers

Naming. I agree in advance with any changes you suggest, and this is
another reason I am sending it early.



Also. This is completely off-topic wrt ptrace cleanups, but if we
change do_wait() now perhaps it makes sense to optimize do_wait()
in PIDTYPE_PID case. In this case we do not need to scan the lists,
we can inspect the task directly. This change should be simple, but
it will increase .text. Do you think it makes sense?


I do not plan any other cleanups before changing ptrace internals.

Oleg.

