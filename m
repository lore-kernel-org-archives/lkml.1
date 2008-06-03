Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbYFCVPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbYFCVPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYFCVPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:15:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbYFCVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:14:59 -0400
Date: Tue, 3 Jun 2008 14:14:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: ebiederm@xmission.com, mingo@elte.hu, torvalds@linux-foundation.org,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] introduce PF_KTHREAD flag
Message-Id: <20080603141416.43afaeba.akpm@linux-foundation.org>
In-Reply-To: <20080601153042.GA8238@tv-sign.ru>
References: <20080601153042.GA8238@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 19:30:42 +0400
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Introduce the new PF_KTHREAD flag to mark the kernel threads. It is set by
> INIT_TASK() and copied to the forked childs (we could set it in kthreadd()
> along with PF_NOFREEZE instead).
> 
> daemonize() was changed as well. In that case testing of PF_KTHREAD is racy,
> but daemonize() is hopeless anyway.
> 
> This flag is cleared in do_execve(), before search_binary_handler(). Probably
> not the best place, we can do this in exec_mmap() or in start_thread(), or
> clear it along with PF_FORKNOEXEC. But I think this doesn't matter in practice,
> and if do_execve() fails kthread should die soon.

The changelog doesn't explain why this change is being made, and I
wasn't able to work that out.

Similarly, I can kinda see what benefit "[PATCH 2/3] kill
PF_BORROWED_MM in favour of PF_KTHREAD" is bringing us, but it would be
nice to see that spelled out please.


