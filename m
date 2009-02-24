Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbZBXQGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbZBXQGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZBXQGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:06:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40289 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZBXQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:06:36 -0500
Date: Tue, 24 Feb 2009 17:24:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: Performance regression in write() syscall
Message-ID: <20090224162443.GW26292@one.firstfloor.org>
References: <20090224020304.GA4496@google.com> <200902241510.33911.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0902232021310.3111@localhost.localdomain> <200902242002.37555.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0902240744500.3111@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902240744500.3111@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 07:52:34AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 24 Feb 2009, Nick Piggin wrote:
> >
> > > it does make some kind of sense to try to avoid the noncached versions for
> > > small writes - because small writes tend to be for temp-files.
> > 
> > I don't see the significance of a temp file. If the pagecache is truncated,
> > then the cachelines remain dirty and so you can't avoid an eventual store
> > back to RAM? 
> 
> No, because many small files end up being used as scratch-pads (think 
> shell script sequences etc), and get read back immediately again. Doing 
> non-temporal stores might just be bad simply because trying to play games 
> with caching may simply do the wrong thing.

I usually recommend to use shmfs for /tmp. Perhaps that should be done
more widely.

BTW I got some upcomming patches to improve c_*_u() and memcpy
on modern Intel x86 CPUs.

-Andi

