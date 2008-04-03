Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYDCXLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYDCXLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYDCXLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:11:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbYDCXLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:11:33 -0400
Date: Thu, 3 Apr 2008 16:11:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [RESEND][RFC v3 PATCH] RTTIME watchdog timer proc interface
Message-Id: <20080403161106.fe260fd7.akpm@linux-foundation.org>
In-Reply-To: <47F55D8D.3060700@ct.jp.nec.com>
References: <47F55D8D.3060700@ct.jp.nec.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Apr 2008 15:43:25 -0700
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Introduce new proc interface for RTTIME watchdog.
> It makes administrator able to set RTTIME watchdog to exisiting real-time
> applications without impact. It's useful we don't want to change software
> stack, but want to use RTTIME watchdog for that software.

Well you don't really need to change the software stack.  It's a matter of
setting RLIMIT_RTTIME in the parent process before starting the stack up. 
This is not much more work than poking at /proc/<pid>/rttime afterwards.

Although setting RLIMIT_RTTIME via fork() is much less useful than being
able to alter it at runtime.

>  fs/proc/base.c |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

And that's rather a lot of new code just for RLIMIT_RTTIME.  And
RLIMIT_RTTIME is not the only rlimit which has this problem - generally the
rlimit interface is a rather nasty one.


I think we should look at creating a general way of modifying and reading a
running process's rlimits.  If we want to do that, a syscall would be the
appropriate interface.

