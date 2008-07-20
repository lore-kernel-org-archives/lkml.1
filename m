Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbYGTDUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbYGTDUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 23:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYGTDUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 23:20:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947AbYGTDUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 23:20:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: kill mm->core_done
In-Reply-To: Oleg Nesterov's message of  Tuesday, 15 July 2008 18:07:15 +0400 <20080715140715.GA25824@tv-sign.ru>
References: <20080715140715.GA25824@tv-sign.ru>
Emacs: ed  ::  20-megaton hydrogen bomb : firecracker
Message-Id: <20080720032001.E707315421D@magilla.localdomain>
Date: Sat, 19 Jul 2008 20:20:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is indeed ugly.  I think the place to start is with moving all the
coredump code out of exit_mm() into a new subfunction that is just passed
the mm pointer, and doing the same with coredump_finish() as you've done,
but leaving the completion logic inside those functions the same.  If all
references to the core_* fields in mm_struct are inside coredump_*()
functions, then that is a good basis for the future cleanups.


Thanks,
Roland
