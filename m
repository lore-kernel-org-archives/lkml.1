Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbXKTVoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbXKTVoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbXKTVof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:44:35 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:48439 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbXKTVoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:44:34 -0500
Date: Wed, 21 Nov 2007 00:43:44 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] kill PT_PTRACED
Message-ID: <20071120214344.GA177@tv-sign.ru>
References: <20071120152133.GA4546@tv-sign.ru> <20071120210840.94CB726F8BE@magilla.localdomain> <20071120212031.GA157@tv-sign.ru> <20071120212851.EEB5026F8BE@magilla.localdomain> <20071120133743.117c4e61.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120133743.117c4e61.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20, Andrew Morton wrote:
>
> On Tue, 20 Nov 2007 13:28:51 -0800 (PST)
> Roland McGrath <roland@redhat.com> wrote:
> 
> > > Andrew, it is very easy to send the new patch to fix the code, but is it
> > > possible to fix the changelog somehow for the patch in -mm tree?
> 
> Sure, just send me the new text.
> 
> > I'd prefer a comment in the code there making it explicit that ->sighand is
> > a "reaped yet" synchronization check (under tasklist_lock).
> 
> that works too.

Will do tomorrow. Actually, I just realized we don't need need either check.
release_task() first does ptrace_unlink(), then __exit_signal(). This means
that (child->ptrace & PT_PTRACED) under tasklist_lock implies we have the valid
->sighand/signal.

Will send the patch with the comment.

Oleg.

