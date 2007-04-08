Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXDHQU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXDHQU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 12:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXDHQU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 12:20:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48584 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXDHQUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 12:20:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
References: <20070408155337.GA126@tv-sign.ru>
Date: Sun, 08 Apr 2007 10:19:48 -0600
In-Reply-To: <20070408155337.GA126@tv-sign.ru> (Oleg Nesterov's message of
	"Sun, 8 Apr 2007 19:53:37 +0400")
Message-ID: <m1lkh23kkb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> For review only.
>
> To implement for-in-kerenl-use-only CLONE_ flags, we need to filter out them
> in sys_clone().

Nack

The current clone_flags field is for user space consumption and we
have proposed users for all or almost all of the remaining bits.

If we are going to have kernel only flags please use an additional
argument to do_fork and copy_process.

Your current scheme also has the bad side that if user space supplied
a kernel flag it is hard to detect it and return -EINVAL.  Which
limits future expansion.  Silently dropping clone flags is a real
pain, if you are trying to detect if a new flag has been implemented.

Eric
