Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbXLFBI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbXLFBI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 20:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXLFBIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 20:08:49 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:49091 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXLFBIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 20:08:49 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 5 Dec 2007 17:08:47 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix group stop with exit race
In-Reply-To: <20071205173028.GA3745@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0712051704590.6288@alien.or.mcafeemobile.com>
References: <20071205173028.GA3745@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2007, Oleg Nesterov wrote:

> do_signal_stop() counts all sub-thread and sets ->group_stop_count accordingly.
> Every thread should decrement ->group_stop_count and stop, the last one should
> notify the parent.
> 
> However a sub-thread can exit before it notices the signal_pending(), or it may
> be somewhere in do_exit() already. In that case the group stop never finishes
> properly.
> 
> Note: this is a minimal fix, we can add some optimizations later. Say we can
> return quickly if thread_group_empty(). Also, we can move some signal related
> code from exit_notify() to exit_signals().
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Looks OK for me, even though we're doing more work on the exit path. OTOH 
I don't see a non-racy way of doing it w/out grabbing the lock. Did you 
try to bench how much this change costs?
Anyway, looks sane to me...

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


