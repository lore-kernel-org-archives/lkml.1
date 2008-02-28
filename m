Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbYB1Q4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbYB1Q4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYB1Q4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:56:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:37012 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750712AbYB1Q4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:56:32 -0500
Date: Thu, 28 Feb 2008 17:56:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] handle_stop_signal: don't wake up the stopped task until
 it sees SIGCONT
In-Reply-To: <20080228164529.GA12695@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0802281756010.3391@jikos.suse.cz>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
 <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
 <20080228102649.071572700FD@magilla.localdomain> <20080228153043.GA11484@tv-sign.ru>
 <Pine.LNX.4.64.0802281633540.3391@jikos.suse.cz> <20080228160834.GA11510@tv-sign.ru>
 <Pine.LNX.4.64.0802281711500.3391@jikos.suse.cz> <20080228164529.GA12695@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Oleg Nesterov wrote:

> -------------------------------------------------------------------------------
> [PATCH] handle_stop_signal: don't wake up the stopped task until it sees SIGCONT
> 
> The bug was found by Jiri Kosina <jkosina@suse.cz>, and the patch is based
> on his ideas.
> handle_stop_signal(SIGCONT) wakes up the stopped task and unlocks ->siglock
> for do_notify_parent_cldstop(p, CLD_CONTINUED). The woken task returns from
> do_signal_stop(), takes ->siglock and resumes to user-space without actually
> seeing SIGCONT which may have a handler.
> Move the code realated to do_notify_parent_cldstop(CLD_CONTINUED) up, before
> "wake_up_state(t, state)".
> NOTE: It is possible that the subsequent rm_from_queue(SIG_KERNEL_STOP_MASK)
> removes SIGSTOP which comes after SIGCONT when we drop ->siglock. Not nice,
> but possible even without this change. Hopefully we can remove the parent
> notifying code from the sender path completely, but this needs more thinking.
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs
