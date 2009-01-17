Return-Path: <linux-kernel-owner+w=401wt.eu-S1762989AbZAQPmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762989AbZAQPmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761089AbZAQPlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:41:49 -0500
Received: from netgear.net.ru ([195.178.208.66]:55259 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760902AbZAQPls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:41:48 -0500
Date: Sat, 17 Jan 2009 18:41:47 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Bodo Eggert <7eggert@gmx.de>
Cc: David Rientjes <rientjes@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090117154147.GA12863@ioremap.net>
References: <bTEeI-5Y0-15@gated-at.bofh.it> <bTGTe-1K5-3@gated-at.bofh.it> <bTNi6-3kb-9@gated-at.bofh.it> <bTOea-4QT-1@gated-at.bofh.it> <bTQ6f-7Qs-1@gated-at.bofh.it> <bTQpv-5o-3@gated-at.bofh.it> <bTQzd-iK-5@gated-at.bofh.it> <bTXhp-2IA-31@gated-at.bofh.it> <bTZjb-62D-25@gated-at.bofh.it> <E1LOCze-00020X-GT@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LOCze-00020X-GT@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 04:21:50PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:
> > The only sane way to use oom_adj is
> > to disable oom killer for the task or make its score very small or very
> > big, there is really no way to make a finegrained tuning, since score
> > changes and userspace does not know the algorithm.
> 
> It does not need to know, it just has to tune until it's about level with
> the other normal processes if it's to be a normal process, and add or
> substract one or two to oom_adj if it's avery (un)important process.

Did you try such tuning yourself? I submitted documentation update on
how score is calculated, there is really no way admin can do that in
some script or manually, and relying on oom_score content is not very
precise since it jumps all over the range depending on the read time.

So, forget that you can tune oom_adj system-wide, it is only possible to
effectively enable or disable it. If there are two identical processes,
it is possible in theory to tune them against each other, but practice
and theory are the same only in theory, in practice one of the processes
will suddenly start doing different things and all your calculus
immediately become wrong.

OOM scores can not be reliably tuned system-wide.

-- 
	Evgeniy Polyakov
