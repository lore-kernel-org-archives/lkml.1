Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbXLBS5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbXLBS5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbXLBS5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:57:36 -0500
Received: from ns1.suse.de ([195.135.220.2]:56952 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXLBS5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:57:36 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
From: Andi Kleen <andi@firstfloor.org>
References: <20071201092037.GA32544@elte.hu>
Date: Sun, 02 Dec 2007 19:57:30 +0100
In-Reply-To: <20071201092037.GA32544@elte.hu> (Ingo Molnar's message of "Sat\, 1 Dec 2007 10\:20\:37 +0100")
Message-ID: <p737ijwylet.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> this patch extends the soft-lockup detector to automatically
> detect hung TASK_UNINTERRUPTIBLE tasks. Such hung tasks are
> printed the following way:

That will likely trigger anytime a hard nfs/cifs mount loses its
server for 120s. To make this work you would need a new 
TASK_UNINTERRUPTIBLE_EXTERNAL_EVENT or similar and mark
all the places which depend on those.

I've also seen kernel modules that use semaphores like wait queues
While that gives a little funny results (high load average) it worked 
so far, until this patch.

-Andi
