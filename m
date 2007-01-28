Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbXA1PTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbXA1PTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbXA1PTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:19:48 -0500
Received: from main.gmane.org ([80.91.229.2]:58273 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbXA1PTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:19:47 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: O_DIRECT question
Date: Sun, 28 Jan 2007 10:18:38 -0500
Message-ID: <45BCBECE.4080405@tmr.com>
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701252211.39017.vda.linux@googlemail.com> <45BA4720.5010406@tmr.com> <200701270035.31285.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Michael Tokarev <mjt@tls.msk.ru>, Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org, kenneth.w.chen@in
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <200701270035.31285.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko wrote:
> On Friday 26 January 2007 19:23, Bill Davidsen wrote:
>> Denis Vlasenko wrote:
>>> On Thursday 25 January 2007 21:45, Michael Tokarev wrote:
>>>> Phillip Susi wrote:

	[...]

>>>> But even single-threaded I/O but in large quantities benefits from O_DIRECT
>>>> significantly, and I pointed this out before.
>>> Which shouldn't be true. There is no fundamental reason why
>>> ordinary writes should be slower than O_DIRECT.
>>>
>> Other than the copy to buffer taking CPU and memory resources.
> 
> It is not required by any standard that I know. Kernel can be smarter
> and avoid that if it can.

Actually, no, the whole idea of page cache is that overall system i/o 
can be faster if data sit in the page cache for a while. But the real 
problem is that the application write is now disconnected from the 
physical write, both in time and order.

No standard says the kernel couldn't do direct DMA, but since having 
that required is needed to guarantee write order and error status linked 
to the actual application i/o, what a kernel "might do" is irrelevant.

It's much easier to do O_DIRECT by actually doing the direct i/o than to 
try to catch all the corner cases which arise in faking it.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

