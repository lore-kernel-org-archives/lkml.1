Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab0BCIY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 03:24:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59133 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab0BCIY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 03:24:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for child processes
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100202120457.GA19605@omega>
References: <20100202120457.GA19605@omega>
Message-Id: <20100203172006.D3B2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  3 Feb 2010 17:24:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [ I already sent this patch half a year ago or so, as an RFC. I didn't
> really get any comments back then, however I am still interested in
> seeing this patch in the kernel tree. So here I go again: please
> comment! I have updated the patch to apply to the current upstream git
> master. ]
> 
> Right now, if a process dies all its children are reparented to init.
> This logic has good uses, i.e. for double forking when daemonizing.
> However it also allows child processes to "escape" their parents, which
> is a problem for software like session managers (such as gnome-session)
> or other process supervisors.

I think you need to explain why this patch improve gnome-session.

 - What's happen on current gnome-session. and When?
 - After the patch, Which behavior will be changed?
 - Why do you think gnome-session can ignore old kernel?
 - etc..

We don't have any input for judgement and advise.



> 
> This patch adds a simple flag for each process that marks it as an
> "anchor" process for all its children and grandchildren. If a child of
> such an anchor dies all its children will not be reparented to init, but
> instead to this anchor, escaping this anchor process is not possible. A
> task with this flag set hence acts is little "sub-init".
> 
> Anchors are fully recursive: if an anchor dies, all its children are
> reparented to next higher anchor in the process tree.
> 
> This is orthogonal to PID namespaces. PID namespaces virtualize the
> actual IDs in addition to introducing "sub-inits". This patch introduces
> "sub-inits" inside the same PID namespace.
> 
> This patch is compile tested only. It's relatively trivial, and is
> written in ignorance of the expected locking logic for accessing
> task_struct->parent. This mail is primarily intended as a request for
> comments. So please, I'd be happy about any comments!


