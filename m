Return-Path: <linux-kernel-owner+w=401wt.eu-S1761028AbYBGCK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761028AbYBGCK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 21:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbYBGCKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 21:10:51 -0500
Received: from fmailhost05.isp.att.net ([207.115.11.55]:53575 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220AbYBGCKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 21:10:50 -0500
X-Originating-IP: [72.147.214.119]
Message-ID: <47AA68AA.3090009@bellsouth.net>
Date: Wed, 06 Feb 2008 20:10:50 -0600
From: "J. K. Cliburn" <jacliburn@bellsouth.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: MM kernels 2.6.24-rc*-mm*, 2.6.24-mm1: gnome-terminal stuck in
 tty_poll
References: <1202326722.7488.46.camel@localhost>
In-Reply-To: <1202326722.7488.46.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zan Lynx wrote:

> gnome-terminal gets stuck.

I began seeing this very thing around 2.6.24 time.  (Fedora 8, vanilla 
kernel.)  I could usually cause the gnome terminal to hang if I rapidly 
resized the window while executing make check-headers.

Over a couple of days I bisected it down to this commit:

Commit:     37bb6cb4097e29ffee970065b74499cbf10603a3
Parent:     d3d74453c34f8fd87674a8cf5b8a327c68f22e99
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri Jan 25 21:08:32 2008 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri Jan 25 21:08:32 2008 +0100

     hrtimer: unlock hrtimer_wakeup

     hrtimer_wakeup creates a

       base->lock
         rq->lock

     lock dependancy. Avoid this by switching to 
HRTIMER_CB_IRQSAFE_NO_SOFTIRQ
     which doesn't hold base->lock.

     This fully untangles hrtimer locks from the scheduler locks, and allows
     hrtimer usage in the scheduler proper.

     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
     Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
  kernel/hrtimer.c |    4 +++-
  1 files changed, 3 insertions(+), 1 deletions(-)


Reverting the commit seemed to fix the problem for me.

Then I went away on a business trip Monday morning and returned Tuesday 
night to a dead computer (won't POST), so I can't do any further 
troubleshooting until I get it fixed.

Try reverting that patch and see if your gnome-terminal freezes go away.

Jay
