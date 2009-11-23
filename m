Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbZKWPeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbZKWPeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZKWPeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:34:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:50186 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbZKWPeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:34:18 -0500
Subject: Re: [PATCH v2 10/12] Maintain preemptability count even for
 !CONFIG_PREEMPT kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       riel@redhat.com
In-Reply-To: <1258985167-29178-11-git-send-email-gleb@redhat.com>
References: <1258985167-29178-1-git-send-email-gleb@redhat.com>
	 <1258985167-29178-11-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 16:34:15 +0100
Message-ID: <1258990455.4531.594.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 16:06 +0200, Gleb Natapov wrote:
> Do not preempt kernel. Just maintain counter to know if task can be rescheduled.
> Asynchronous page fault may be delivered while spinlock is held or current
> process can't be preempted for other reasons. KVM uses preempt_count() to check if preemptions is allowed and schedule other process if possible. This works
> with preemptable kernels since they maintain accurate information about
> preemptability in preempt_count. This patch make non-preemptable kernel
> maintain accurate information in preempt_count too.

I'm thinking you're going to have to convince some people this won't
slow them down for no good.

Personally I always have PREEMPT=y, but other people seem to feel
strongly about not doing so.

