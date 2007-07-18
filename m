Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbXGRDaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbXGRDaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 23:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXGRDaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 23:30:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52200 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbXGRD37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 23:29:59 -0400
Message-ID: <469D8932.9080101@garzik.org>
Date: Tue, 17 Jul 2007 23:29:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by warnings
References: <20070717214239.GF28448@devserv.devel.redhat.com>	<ada8x9epuip.fsf@cisco.com> <469D3E66.3010502@garzik.org>	<adamyxuo2w6.fsf@cisco.com>	<alpine.LFD.0.999.0707171954230.27353@woody.linux-foundation.org> <adaejj6o1aw.fsf@cisco.com>
In-Reply-To: <adaejj6o1aw.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> In this case the code is basically
> 
> 	u32 x;
> 
> 	for (n = 0; cond; ++n) {
> 		...
> 		if (!n)
> 			x = something;
> 		...
> 	}
> 
> 	if (n) {
> 		...
> 		use(x);
> 		...
> 	}
> 
> and gcc still warns...


Interestingly, the above accurately describes a common code pattern 
matching code which caused gcc to emit the uninit'd-var warnings.

For the record I think initializating 'f0' to zero is safer for the 
reasons Linus gave, and in addition, f0 is or'd with a value written to 
a hardware register, which means things should go awry (if they go) in a 
semi-predictable manner.

According to the assembly language produced, sure it is larger -- by one 
(per function) MOV that is adjacent to other initializations, making it 
highly likely the initializations are all streamed together.  I doubt 
one MOV per function will make a huge difference, considering the peace 
of mind it buys.

	Jeff


