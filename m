Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYH0SIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYH0SIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYH0SHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:07:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45934 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbYH0SHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:07:54 -0400
Date: Wed, 27 Aug 2008 11:04:30 -0700
From: sukadev@us.ibm.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] pid_ns: (BUG 11391) change ->child_reaper when
	init->group_leader exits
Message-ID: <20080827180430.GA4397@us.ibm.com>
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

Oleg Nesterov [oleg@tv-sign.ru] wrote:
| We don't change pid_ns->child_reaper when the main thread of the
| subnamespace init exits. As Robert Rex <robert.rex@exasol.com>
| pointed out this is wrong.
| 
| Yes, the re-parenting itself works correctly, but if the reparented
| task exits it needs ->parent->nsproxy->pid_ns in do_notify_parent(),
| and if the main thread is zombie its ->nsproxy was already cleared
| by exit_task_namespaces().
| 
| Introduce the new function, find_new_reaper(), which finds the new
| ->parent for the re-parenting and changes ->child_reaper if needed.
| Kill the now unneeded exit_child_reaper().
| 
| Also move the changing of ->child_reaper from zap_pid_ns_processes()
| to find_new_reaper(), this consolidates the games with ->child_reaper
| and makes it stable under tasklist_lock.
| 
| Reported-by: Robert Rex <robert.rex@exasol.com>
| Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
