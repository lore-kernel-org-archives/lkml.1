Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbYFRC1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbYFRC1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 22:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759527AbYFRC1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 22:27:23 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40231 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759495AbYFRC1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 22:27:23 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2008 22:27:23 EDT
Date: Wed, 18 Jun 2008 12:27:12 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
	bisected, reproducable)
Message-ID: <20080618022712.GB1383@brong.net>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 02:20:49PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 17 Jun 2008, Linus Torvalds wrote:
> > 
> > Hmm. Something like this *may* salvage it.
> > 
> > Untested, so far (I'll reboot and test soon enough), but even if it fixes 
> > things, it's not really very good. 
> 
> Ok, so I just rebooted with this, and it does indeed fix the bug.
> 
> I'd be happier with a more complete fix (ie being byte-accurate and 
> actually doing the partial copy when it hits a fault in the middle), but 
> this seems to be the minimal fix, and at least fixes the totally bogus 
> return values from the x86-64 __copy_user*() functions.
> 
> Not that I checked that I got _all_ cases correct (and maybe there are 
> other versions of __copy_user that I missed entirely), but Bron's 
> test-case at least seems to work properly for me now.
> 
> Bron? If you have a more complete test-suite (ie the real-world case that 
> made you find this), it would be good to verify the whole thing. 

I have a real world test case using "cyr_dbtool" from Cyrus 2.3.12 on a
known-bug-inducing piece of data (the key and value sizes in the example
code were taken from that.  Indeed, the example code started off
building byte-for-byte identical files, then I changed it to write only
a single character across the entire key and value so the hexdump was
shorter)

I'll give it a go.

Bron.
