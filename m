Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbYFQWLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbYFQWLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbYFQWLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:11:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39827 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981AbYFQWLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:11:22 -0400
Date: Tue, 17 Jun 2008 23:11:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
	bisected, reproducable)
Message-ID: <20080617221118.GM28946@ZenIV.linux.org.uk>
References: <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <485829A1.4020705@firstfloor.org> <alpine.LFD.1.10.0806171421100.2907@woody.linux-foundation.org> <20080617213618.GL28946@ZenIV.linux.org.uk> <48582FAB.1020402@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48582FAB.1020402@firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 11:42:03PM +0200, Andi Kleen wrote:

> What seems also confusing him is that x86-64 copy_from/to_user use a shared
> subfunction. The trick that this subfunction uses is to assume that
> either the destination faults or the source, but never both. It's legal
> because the caller should never pass in a faulting source for copy to
> or a faulting destination for copy from.
> 
> Actually they handle it, but the return value is not correct.
> 
> Now he "fixed" copy_to_user to return a kind of correct return value
> for source faults, but it'll of course break copy_from_user()'s return value.
> 
> It's still unclear why his patch fixes the test case. The caller should
> be using copy_in_user perhaps? Or is it just buggy by passing something
> unmapped to copy_to_user?

AFAICS, what happened is that b0rken copy_*FROM*_user() had been discussed
with references to copy_*TO*_user().  With proposed patch indeed not affecting
any legitimate calls of the latter.  Does affect the former and that, from
my reading of the code in question, correctly.

IOW, s/copy_to_user/copy_from_user/ in Linus' postings upthread and they
make sense.
