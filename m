Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbZFBBRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbZFBBRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 21:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZFBBRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 21:17:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51179 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZFBBRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 21:17:06 -0400
Message-Id: <200906020116.n521GsHk097628@www262.sakura.ne.jp>
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: serge@hallyn.com
Cc: serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 10:16:54 +0900
References: <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org> <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp> <200905250037.n4P0bFwe057503@www262.sakura.ne.jp> <200905250039.n4P0dSIE058041@www262.sakura.ne.jp> <200905250041.n4P0fVCT058575@www262.sakura.ne.jp> <200906012227.FDE64040.MVQLOStOHFOFFJ@I-love.SAKURA.ne.jp> <20090602001137.GA20880@hallyn.com> <200906020030.n520UU1D087893@www262.sakura.ne.jp> <20090602010349.GB20977@hallyn.com>
In-Reply-To: <20090602010349.GB20977@hallyn.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 01062009 #2072025, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> All readers should walk the list under rcu_read_lock, so if the manage
> to reach ->entry, then entry.list->next will be a valid entry on the live
> list until the next rcu cycle.

I have to tell you one thing.
Reader traverses the list via read(2) system call.
It means that reader can't read all elements in the list within a single
read(2) system call.
Thus, reader grabs a reference on an element (i.e. p->entry.users) before
leaving reader section and drops that reference after entering reader section.

Yes, it would be possible for readers to walk the list under rcu_read_lock(),
but it is not sufficient for GC to simply call synchronize_rcu(). GC has to
wait for p->entry.users to become 0 before modifying p->entry.list.next .

> BTW I'm not telling you have to do this, so if you just don't want to, then
> just say so.  But so long as you come back to me with technical reasons
> why you can't, then I take it you're interested in a technical solution :)
> and can't help but respond...

I see. I'll post only (1) and (2).

Thank you for your suggestion and time.
