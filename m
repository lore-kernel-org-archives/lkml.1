Return-Path: <linux-kernel-owner+w=401wt.eu-S1763996AbYBTOhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763996AbYBTOhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759331AbYBTOg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:36:59 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:51186 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160AbYBTOg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:36:58 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: inode leak in 2.6.24?
References: <87hcg9hkpp.fsf@szonett.ki.iif.hu>
	<20080218215344.GM155407@sgi.com> <87skzoanq3.fsf@szonett.ki.iif.hu>
	<20080220010405.GF155407@sgi.com>
Date: Wed, 20 Feb 2008 15:36:53 +0100
In-Reply-To: <20080220010405.GF155407@sgi.com> (David Chinner's message of
	"Wed, 20 Feb 2008 12:04:06 +1100")
Message-ID: <87fxvny9ru.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:

> The xfs inodes are clearly pinned by the dentry cache, so the issue
> is dentries, not inodes. What's causing dentries not to be
> reclaimed?  I can't see anything that cold pin them (e.g. no filp's
> that would indicate open files being responsible), so my initial
> thoughts are that memory reclaim may have changed behaviour.
>
> I guess the first thing to find out is whether memory pressure
> results in freeing the dentries. To simulate memory pressure causing
> slab cache reclaim, can you run:
>
> # echo 2 > /proc/sys/vm/drop_caches
>
> and see if the number of dentries and inodes drops. If the number
> goes down significantly, then we aren't leaking dentries and there's
> been a change in memoy reclaim behaviour. If it stays the same, then
> we probably are leaking dentries....

Hi Dave,

Thanks for looking into this.  There's no real conclusion yet: the
simulated memory pressure sent the numbers down allright, but
meanwhile it turned out that this is a different case: on this machine
the increase wasn't a constant growth, but related to the daily
updatedb job.  I'll reload the original kernel on the original
machine, and collect the same info if the problem reappers.
-- 
Regards,
Feri.
