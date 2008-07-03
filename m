Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYGCWxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYGCWxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbYGCWx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:53:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755808AbYGCWx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:53:29 -0400
Date: Thu, 3 Jul 2008 15:53:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linuxfoundation.org,
       peterz@infradead.org, stable@kernel.org
Subject: Re: [PATCH] hrtimer: prevent migration for raising softirq
Message-Id: <20080703155302.5f86d8f4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0807031428440.7798@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807031428440.7798@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008 14:31:26 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> Due to a possible deadlock, the waking of the softirq was pushed outside
> of the hrtimer base locks. See commit 0c96c5979a522c3323c30a078a70120e29b5bdbc

Please quote at least the patch title rather than raw hashes.

afaict that patch isn't in 2.6.25 yet you copied stable@kernel.org. 
Please clarify.

> 
> Unfortunately this allows the task to migrate after setting up the softirq
> and raising it. Since softirqs run a queue that is per-cpu we may raise the
> softirq on the wrong CPU and this will keep the queued softirq task from
> running.
> 
> To solve this issue, this patch disables preemption around the releasing
> of the hrtimer lock and raising of the softirq.
> 

This seems to be 2.6.26 material and is inapplicable to 2.6.25?
