Return-Path: <linux-kernel-owner+w=401wt.eu-S933975AbXEVQqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbXEVQqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbXEVQqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:46:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53079 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758993AbXEVQqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:46:25 -0400
Message-ID: <46531E58.6030506@garzik.org>
Date: Tue, 22 May 2007 12:46:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: kkeil@suse.de
CC: Andrew Morton <akpm@linux-foundation.org>, kai.germaschewski@gmx.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ISDN: move card state init to separate function
References: <20070522124458.GA25591@havoc.gtf.org> <20070522151814.GA4280@pingi.kke.suse.de>
In-Reply-To: <20070522151814.GA4280@pingi.kke.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Keil wrote:
> So what is the reason to do this now, does this block some changes in
> other places ? I did not change this code for long time because I know
> that this is a nightmare, the code was grown and grown (supporting more and
> more cards/chipsets) and is really nothing which should be used in future.
> So I would say it maybe better, if it doesn't block anything else, to
> replace HiSax completely with a new modular design. I know that here was not
> so much effort in the past years, but now I got some time to push mISDN
> forward and it looks not so bad to get the first parts ready for mainline
> in June.

ISDN is the biggest chunk of code blocking removal of some deprecated 
PCI interfaces.

If you want to replace the code completely with a newfangled modular 
design, I will gladly step out of the way and let that happen :)  I only 
know what I see right now, which is code that has sat around for a while 
not getting updated to the new PCI API.

Since I do not have any ISDN hardware, my plan was to do equivalent 
transformations of the code.  Each patch just shuffles code, but 
maintains a working state at all time, making it trivial to prove 
(mathematically, or with testing, or with git-bisect) that the code 
continues to work.

So, just tell me which you would prefer.  If you are going to fix all 
this stuff, there is plenty of other stuff on my list to work on. 
Otherwise I will create equivalent-transform patches that take the 
existing code and modify it just enough to be correct for the new PCI API.

	Jeff


