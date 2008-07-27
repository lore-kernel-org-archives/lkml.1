Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbYG0Qzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbYG0Qzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 12:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbYG0Qzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 12:55:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756755AbYG0Qze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 12:55:34 -0400
Date: Sun, 27 Jul 2008 09:51:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: akpm@linux-foundation.org, roland@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Q: wait_task_inactive() and !CONFIG_SMP && CONFIG_PREEMPT
In-Reply-To: <20080727121540.GB178@tv-sign.ru>
Message-ID: <alpine.LFD.1.10.0807270948410.3486@nehalem.linux-foundation.org>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org> <20080727121540.GB178@tv-sign.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Jul 2008, Oleg Nesterov wrote:
>
> Without CONFIG_SMP wait_task_inactive() is noop, this doesn't look right.
> Shouldn't we also take CONFIG_PREEMPT into account?

The exit path had _better_ be non-preemptable until it hits the final 
schedule that disables it (and that wait_task_inactive() was waiting for). 
At least that used to be the rule.

Of course, historically the only user for this was just the "wait for 
exit to complete" case. And that isn't really true any more, I guess. So I 
dunno.

		Linus
