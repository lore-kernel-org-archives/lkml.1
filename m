Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbXLEM4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbXLEM4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 07:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXLEM4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 07:56:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35831 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbXLEM4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 07:56:45 -0500
Date: Wed, 5 Dec 2007 13:56:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/5] Use macros instead of TASK_ flags
Message-ID: <20071205125622.GA21531@elte.hu>
References: <11932286982175-git-send-email-matthew@wil.cx> <1193228698799-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193228698799-git-send-email-matthew@wil.cx>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> +#define is_task_stopped(task)	((task->state & TASK_STOPPED) != 0)
> +#define is_task_stopped_or_traced(task)	\
> +			((task->state & (TASK_STOPPED | TASK_TRACED)) != 0)
> +#define is_task_loadavg(task)	((task->state & TASK_UNINTERRUPTIBLE) != 0)

1) please change 'is' and 'task' around so that it reads nicer:

   if (task_is_stopped(t))

instead of the tongue-twister:

   if (is_task_stopped(t))

2) please change task_is_loadavg() to something more sensible - i didnt 
know what it meant when i first saw it in -mm's sched.c. 
task_is_uninterruptible() would be the logical choice ...

	Ingo

