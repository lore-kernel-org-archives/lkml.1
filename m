Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbYHAUWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbYHAUWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYHAUWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:22:34 -0400
Received: from gw.goop.org ([64.81.55.164]:45383 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYHAUWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:22:33 -0400
Message-ID: <48937084.8020200@goop.org>
Date: Fri, 01 Aug 2008 13:22:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: lock_set_subclass - reset a held lock's subclass
References: <20080731.155504.167792984.davem@davemloft.net>  <20080801.011122.32782916.davem@davemloft.net>  <20080801090100.GA25142@elte.hu>  <20080801.021348.233313767.davem@davemloft.net> <1217588920.9686.6.camel@twins> <489350AE.1030609@goop.org> <alpine.LFD.1.10.0808011113530.3277@nehalem.linux-foundation.org> <48935FA4.5010804@goop.org> <Pine.LNX.4.64.0808012051380.6485@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808012051380.6485@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Please check the spin_lock_nested() in move_ptes() in mm/mremap.c.
>
> If you have down_write(&mm->mmap_sem) then you should be safe,
> but may need to do something to placate lockdep.  If you don't
> have down_write(&mm->mmap_sem), then I think you're in trouble?
>
> Not a big deal, the move_ptes() locking can be adjusted to suit
> your rule, it was just easier to do it the way it is at the time.

Ah, yes, I did look at that.  I think it isn't an issue, because my code 
is called from dup_mmap(), activate_mm() or exit_mmap().

dup_mmap() already holds mmap_sem.

activate_mm() in exec doesn't hold the sem, but I don't think it's 
possible for anyone to be racing against it.
activate_mm() in unshare doesn't seem to get used.

exit_mmap() gets called when there are no other users, so we'd better 
not be racing...

    J
