Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbYFQWWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbYFQWWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbYFQWVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:21:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34480 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002AbYFQWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:21:52 -0400
Message-ID: <485838F9.8010001@firstfloor.org>
Date: Wed, 18 Jun 2008 00:21:45 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,	bisected,
 reproducable)
References: <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <485829A1.4020705@firstfloor.org> <alpine.LFD.1.10.0806171421100.2907@woody.linux-foundation.org> <20080617213618.GL28946@ZenIV.linux.org.uk> <48582FAB.1020402@firstfloor.org> <20080617221118.GM28946@ZenIV.linux.org.uk>
In-Reply-To: <20080617221118.GM28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> AFAICS, what happened is that b0rken copy_*FROM*_user() had been discussed
> with references to copy_*TO*_user().  With proposed patch indeed not affecting
> any legitimate calls of the latter.  Does affect the former and that, from
> my reading of the code in question, correctly.
> 
> IOW, s/copy_to_user/copy_from_user/ in Linus' postings upthread and they
> make sense.

Yes, it makes some more sense, but I'm not completely happy with the fix
because it makes the fault point reporting very unreliable (maximum error
will be 63 instead of 7 now). iirc especially mount was sensitive to that.

Unfortunately fixing the accuracy is a little tricky.

-Andi
