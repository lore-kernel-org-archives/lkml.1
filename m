Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbXLCAHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbXLCAHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 19:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXLCAHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 19:07:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60474 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbXLCAHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 19:07:43 -0500
Date: Mon, 3 Dec 2007 01:07:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203000741.GB26636@one.firstfloor.org>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202144331.6abf1289@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202144331.6abf1289@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We really need to get better diagnostics for the
> bad-kernel-behavior-that-is-seen-as-bug cases. If we ever want to get
> to the scenario where we have a more or less robust measure of kernel
> quality (and we're not all that far off for several cases), one thing

One measure to kernel quality is to recover well from IO errors
(like network problems or broken block devices)

This patch will likely work against that by breaking error paths.

> This patch is a step in the right direction there, by quite a
> lot.
> 
> I really don't understand what your objection is to this patch... is it
> that an enterprise distro can't ship with it on? (Which is fine btw)

Any distribution aimed at end users cannot ship with it on. 
Most likely not even a standard Linus kernel should really enable
it without warnings.

Also in general I have my doubts that the false positive:real bug
ratio of this warning is well balanced. Just consider the original
example of dead network servers. Even in my relatively small
home network that that is a quite common occurrence. This patch
will break that all by throwing random backtraces when this 
happens.

-Andi

