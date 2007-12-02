Return-Path: <linux-kernel-owner+w=401wt.eu-S1751513AbXLBVeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbXLBVeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 16:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbXLBVeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 16:34:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXLBVeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 16:34:11 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
From: Andi Kleen <andi@firstfloor.org>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de>
	<20071202185945.GA25990@elte.hu>
	<20071202114152.3bf4332d@laptopd505.fenrus.org>
	<20071202200953.GA23994@one.firstfloor.org>
	<20071202202602.GA16480@elte.hu>
	<20071202204725.GA25891@one.firstfloor.org>
	<20071202211027.GA32282@elte.hu>
	<20071202211925.GA26414@one.firstfloor.org>
	<20071202212407.GA11358@elte.hu>
Date: Sun, 02 Dec 2007 22:34:08 +0100
In-Reply-To: <20071202212407.GA11358@elte.hu> (Ingo Molnar's message of "Sun\, 2 Dec 2007 22\:24\:07 +0100")
Message-ID: <p73y7ccwzlb.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> do you realize that more than 120 seconds TASK_UNINTERRUPTIBLE _is_ 
> something that most humans consider as "buggy" in the overwhelming 
> majority of cases, regardless of the reason? Yes, there are and will be 
> some exceptions, but not nearly as countless as you try to paint it. A 
> quick test in the next -mm will give us a good idea about the ratio of 
> false positives.

That would assume error paths get regularly exercised in -mm. 
Doubtful.  Most likely we'll only hear about it after it's
out in the wild on some bigger release.

The problem I have with your patch is that it will mess up Linux (in
particular block/network file system) error handling even more than it
already is. In error handling cases such "unusual" things happen
frequently unfortunately.

I used to fight with this with the NMI watchdog on on x86-64 -- it
tended to trigger regularly on SCSI error handlers for example
disabling interrupts too long while handling the error. They
eventually got all fixed, but with that change they will likely
all start throwing nasty messages again. 

And usually it is not simply broken code neither but really
doing something difficult.

-Andi
