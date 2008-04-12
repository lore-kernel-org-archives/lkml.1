Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYDLUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYDLUsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 16:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYDLUsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 16:48:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52535 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbYDLUsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 16:48:08 -0400
Date: Sat, 12 Apr 2008 14:47:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Roland Dreier <rdreier@cisco.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080412204748.GN11962@parisc-linux.org>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org> <adaskxqrgsl.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaskxqrgsl.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 12:53:30PM -0700, Roland Dreier wrote:
> Just make sure you don't forget the history of completions...  As
> Linus said long ago (http://lwn.net/2001/0802/a/lt-completions.php3):
> 
>   In case anybody cares, the race was that Linux semaphores only protect the
>   accesses _inside_ the semaphore, while the accesses by the semaphores
>   themselves can "race" in the internal implementation. That helps make an
>   efficient implementation, but it means that the race was:

Yes, that text appears in the URL I provided in the mail that started
this thread ;-)

The semaphore rewrite I did does not have this problem (it's less
efficient than the hand-optimised assembler, but much more maintainable).
You're supposed to be using mutexes if you want efficiency anyway.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
