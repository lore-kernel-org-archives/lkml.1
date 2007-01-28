Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXA1RFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXA1RFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbXA1RFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:05:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:31030 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbXA1RFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:05:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=l7+ZAPoMXHHB2pNBwA6lrhBcfWE//8nzLNXqVAT01QOLGA79WvTN4Mo7KhV4apQzjxa9ypsGW0BBncJxyR7VV/3VRe60fRFX7moCVrnRKTMIBV63rQb3psxbp2O1vmSHKFc2ym5LBe1agLyG7l5Nc10Iy2pMRYce6vslQATNH1I=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: O_DIRECT question
Date: Sun, 28 Jan 2007 18:03:08 +0100
User-Agent: KMail/1.8.2
Cc: Michael Tokarev <mjt@tls.msk.ru>, Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org, kenneth.w.chen@in
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701270035.31285.vda.linux@googlemail.com> <45BCBECE.4080405@tmr.com>
In-Reply-To: <45BCBECE.4080405@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701281803.08201.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 January 2007 16:18, Bill Davidsen wrote:
> Denis Vlasenko wrote:
> > On Friday 26 January 2007 19:23, Bill Davidsen wrote:
> >> Denis Vlasenko wrote:
> >>> On Thursday 25 January 2007 21:45, Michael Tokarev wrote:
> >>>> Phillip Susi wrote:
> 
> 	[...]
> 
> >>>> But even single-threaded I/O but in large quantities benefits from O_DIRECT
> >>>> significantly, and I pointed this out before.
> >>> Which shouldn't be true. There is no fundamental reason why
> >>> ordinary writes should be slower than O_DIRECT.
> >>>
> >> Other than the copy to buffer taking CPU and memory resources.
> > 
> > It is not required by any standard that I know. Kernel can be smarter
> > and avoid that if it can.
> 
> Actually, no, the whole idea of page cache is that overall system i/o 
> can be faster if data sit in the page cache for a while. But the real 
> problem is that the application write is now disconnected from the 
> physical write, both in time and order.

Not in O_SYNC case.

> No standard says the kernel couldn't do direct DMA, but since having 
> that required is needed to guarantee write order and error status linked 
> to the actual application i/o, what a kernel "might do" is irrelevant.
> 
> It's much easier to do O_DIRECT by actually doing the direct i/o than to 
> try to catch all the corner cases which arise in faking it.

I still don't see much difference between O_SYNC and O_DIRECT write
semantic.
--
vda
