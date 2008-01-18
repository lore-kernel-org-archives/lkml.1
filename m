Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYARFlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYARFlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYARFlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:41:13 -0500
Received: from ns.suse.de ([195.135.220.2]:33023 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYARFlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:41:12 -0500
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Michael Rubin <mrubin@google.com>, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
From: Andi Kleen <andi@firstfloor.org>
References: <20080115080921.70E3810653@localhost>
	<400562938.07583@ustc.edu.cn>
	<532480950801171307q4b540ewa3acb6bfbea5dbc8@mail.gmail.com>
	<400632190.14601@ustc.edu.cn>
Date: Fri, 18 Jan 2008 06:41:09 +0100
In-Reply-To: <400632190.14601@ustc.edu.cn> (Fengguang Wu's message of "Fri\, 18 Jan 2008 12\:56\:09 +0800")
Message-ID: <p738x2nbsi2.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <wfg@mail.ustc.edu.cn> writes:
>
> Suppose we want to grant longer expiration window for temp files,
> adding a new list named s_dirty_tmpfile would be a handy solution.

How would the kernel know that a file is a tmp file?

> So the question is: should we need more than 3 QoS classes?

[just a random idea; i have not worked out all the implications]

Would it be possible to derive a writeback apriority from the ionice
level of the process originating the IO? e.g. we have long standing
problems that background jobs even when niced and can cause
significant slow downs to foreground processes by starving IO 
and pushing out pages. ionice was supposed to help with that
but in practice it does not seem to have helped too much and I suspect
it needs more prioritization higher up the VM food chain. Adding
such priorities to writeback would seem like a step in the right
direction, although it would of course not solve the problem
completely.

-Andi
