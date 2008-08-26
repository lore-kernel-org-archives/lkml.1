Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbYHZXh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbYHZXh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYHZXhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:37:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42637 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbYHZXhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:37:15 -0400
Date: Tue, 26 Aug 2008 16:33:53 -0700
From: sukadev@us.ibm.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] pid_ns: (BUG 11391) change ->child_reaper when
	init->group_leader exits
Message-ID: <20080826233353.GA21052@us.ibm.com>
References: <20080824154912.GA3780@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824154912.GA3780@tv-sign.ru>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was able to repro the problem without the patchset and could  not
reproduce  with the patchset. But just had a quick question while
reviewing the patches.

Oleg Nesterov [oleg@tv-sign.ru] wrote:
| We don't change pid_ns->child_reaper when the main thread of the
| subnamespace init exits. As Robert Rex <robert.rex@exasol.com>
| pointed out this is wrong.
| 
| Yes, the re-parenting itself works correctly, but if the reparented
| task exits it needs ->parent->nsproxy->pid_ns in do_notify_parent(),

If the task was reparented, then with patch 1/4 its parent would be
the global init (init_pid_ns.child_reaper) right ?

| and if the main thread is zombie its ->nsproxy was already cleared
| by exit_task_namespaces().

If above is true, then even if the main thread's nsproxy is NULL, does
it affect the reparented task ?
