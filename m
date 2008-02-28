Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbYB1Pk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbYB1Pk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbYB1Pkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:40:51 -0500
Received: from styx.suse.cz ([82.119.242.94]:34294 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757253AbYB1Pku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:40:50 -0500
Date: Thu, 28 Feb 2008 16:40:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: <20080228153043.GA11484@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0802281633540.3391@jikos.suse.cz>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
 <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
 <20080228102649.071572700FD@magilla.localdomain> <20080228153043.GA11484@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Oleg Nesterov wrote:

> BTW, I think we have the same problem when handle_stop_signal() does 
> do_notify_parent_cldstop(p, CLD_STOPPED) above. The multithreaded app in 
> the middle of the group stop can resume without actually seeing SIGCONT, 
> no?

Yes, I think so, this would also need fixing.

> Currently I have the very vagues idea, please see the "patch" below (it 
> is not right of course, just for illustration).
> These unlock(->siglock)'s on the signal sending path are really nasty,
> it would be wonderfull to avoid them. Note also sig_needs_tasklist(),
> we take tasklist_lock() exactly because we will probably drop siglock.

Whould it be problematic to change do_notify_parent_cldstop() so that it 
doesn't acquire siglock, but asumes that is is called with siglock held 
instead? I can't immediately see any reason why this shouldn't be 
possible.

> What do you think about the approach at least?

So it basically does the same thing my patch did -- postpones signalling 
the parent until it is safe, right?

Thanks,

-- 
Jiri Kosina
