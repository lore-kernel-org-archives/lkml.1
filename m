Return-Path: <linux-kernel-owner+w=401wt.eu-S1759164AbZAHGUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164AbZAHGUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZAHGUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:20:25 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59572 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZAHGUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:20:24 -0500
Message-Id: <200901080619.n086Jqit020011@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #14 (mmotm 2008-12-30-16-05) 02/10] Singly linked list implementation.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: serue@us.ibm.com
Cc: jmorris@namei.org, akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Jan 2009 15:19:52 +0900
References: <20090101050741.372438529@I-love.SAKURA.ne.jp> <20090101050939.802554261@I-love.SAKURA.ne.jp> <alpine.LRH.1.10.0901051926130.16049@tundra.namei.org> <200901060813.n068DI3Y023188@www262.sakura.ne.jp> <alpine.LRH.1.10.0901062008480.25091@tundra.namei.org> <200901070636.n076aFY0061512@www262.sakura.ne.jp> <20090107190912.GB20311@us.ibm.com>
In-Reply-To: <20090107190912.GB20311@us.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 08012009 #1420234, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> > TOMOYO's singly linked list (which is named as "list1") implementation has
> > below characteristics.
> > 
> >  (1) Supports "add" and "read" operations.
> >  (2) Caller holds a lock when adding, but doesn't hold a lock when reading.
> >  (3) Iteration method (for_each_*) needs to call rcu_dereference() because
> >      caller doesn't hold a lock when reading.
> > 
> > I think it is not a good thing to rename "list1" to "slist".
> 
> How about alist (or aolist) for append-only list?
> 
> The problem with list1 is that it *really* doesn't imply the
> characteristics you cite.
> 
OK.

A developer who reads a code using this list likely wonders
"Why no read_lock() before reading this list?".
Thus, I'd like to rename to "rlfl" (Read-Lock-Free List).
