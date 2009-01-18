Return-Path: <linux-kernel-owner+w=401wt.eu-S933548AbZARMuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbZARMuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 07:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbZARMuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 07:50:08 -0500
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:38973 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063AbZARMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 07:50:07 -0500
Date: Sun, 18 Jan 2009 13:49:58 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Bodo Eggert <7eggert@gmx.de>, David Rientjes <rientjes@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
In-Reply-To: <20090117154147.GA12863@ioremap.net>
Message-ID: <alpine.LSU.0.999.0901181337430.6179@be1.lrz>
References: <bTEeI-5Y0-15@gated-at.bofh.it> <bTGTe-1K5-3@gated-at.bofh.it>
 <bTNi6-3kb-9@gated-at.bofh.it> <bTOea-4QT-1@gated-at.bofh.it>
 <bTQ6f-7Qs-1@gated-at.bofh.it> <bTQpv-5o-3@gated-at.bofh.it>
 <bTQzd-iK-5@gated-at.bofh.it> <bTXhp-2IA-31@gated-at.bofh.it>
 <bTZjb-62D-25@gated-at.bofh.it> <E1LOCze-00020X-GT@be1.7eggert.dyndns.org>
 <20090117154147.GA12863@ioremap.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2009, Evgeniy Polyakov wrote:
> On Sat, Jan 17, 2009 at 04:21:50PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:

> > > The only sane way to use oom_adj is
> > > to disable oom killer for the task or make its score very small or very
> > > big, there is really no way to make a finegrained tuning, since score
> > > changes and userspace does not know the algorithm.
> > 
> > It does not need to know, it just has to tune until it's about level with
> > the other normal processes if it's to be a normal process, and add or
> > substract one or two to oom_adj if it's avery (un)important process.
> 
> Did you try such tuning yourself?

No, I just designed the oom_adj mechanism and left the implementation to 
experienced people.

> I submitted documentation update on
> how score is calculated, there is really no way admin can do that in
> some script or manually, and relying on oom_score content is not very
> precise since it jumps all over the range depending on the read time.

The value is expeted to vary with the read time, since memory usage
does vary, too. If your sshd goes berserk and starts eating memory,
it may be smart to kill it. If it doesn't, the score should remain
about the same.

> So, forget that you can tune oom_adj system-wide, it is only possible to
> effectively enable or disable it.

It is, as long as the score varies with the badness of a process.

> If there are two identical processes,
> it is possible in theory to tune them against each other, but practice
> and theory are the same only in theory, in practice one of the processes
> will suddenly start doing different things and all your calculus
> immediately become wrong.
> OOM scores can not be reliably tuned system-wide.

As I said, if a program starts misbehaving, it's mostly not sane to keep
it alive. Besides that, the oom_adj allows you to special case some
processes to be immortal or to be kenny, but you should be prepared for 
trouble then.
-- 
A Purple Heart just goes to prove that were you smart enough to think of a
plan, stupid enough to try it, and lucky enough to survive.
