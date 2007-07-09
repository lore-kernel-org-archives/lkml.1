Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXGIE3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXGIE3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 00:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXGIE3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 00:29:31 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:25731 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750788AbXGIE3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 00:29:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=26CRGtPapRzIiC+xHfw8q1GykoiVLdTWFQ0rBbYKv6M0ijnaIe6WODIhQ9TRG/nbOzmI8Mein5PYmm+Ah68FzqkIrLSK5+l+wR5SQ+B3xc1R4sQlDR6DQn0EKNYBYWGVaogAh6whg0noEJpJD/Dhzs/8vylOBMJfNtmUIpNQDrs=  ;
X-YMail-OSG: dNeni.oVM1kICALqLPnE_okG.xlagpXYw2Rwd2F3nDOFvRTLH1c4R67faTT7nBpwOZOPywcpcg--
Message-ID: <4691B9A5.6060203@yahoo.com.au>
Date: Mon, 09 Jul 2007 14:29:25 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
CC: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <87tzsew712.fsf@jbms.ath.cx>
In-Reply-To: <87tzsew712.fsf@jbms.ath.cx>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Maitin-Shepard wrote:
> Al Boldi <a1426z@gawab.com> writes:
> 
> 
>>Pavel Machek wrote:
>>
>>>We are stuck with refrigerator for now, and at least for hibernation,
>>>I don't see any feasible alternative.
> 
> 
>>Feasible alternative?
> 
> 
> I posted such an alternative to the list a short time ago: hibenrating
> from a *new* kernel space/user space that is created by loading a new
> kernel in a manner similar to what is done for kexec crashdumps.  Unlike
> kexec crashdumps, however, it would not require reserving any memory at
> boot, because the necessary memory (maybe 16MB or 64MB) can be freed
> just before hibernating, and device drivers can be properly stopped so
> that DMAs don't stomp over certain memory.

This is the Morton method, isn't it? :) I remember it sounding like a
very good idea when he brought it up, but I can't remember the details
of why it was rejected or what the problems were.


> This approach eliminates the need for the freezer, as it would make
> hibernate look a lot a bit like suspend to ram from the perspective of
> the "old" kernel (the kernel being hibernated), as the hibernate
> operation itself would be completely atomic from the perspective of the
> "old" kernel.  That is not to say, of course, that any code paths would
> actually be shared, or that the drivers would do the same things
> (because they probably would not).

Well it basically is suspend to RAM with the additional step that a
new kernel gets booted and writes out the data from RAM to disk then
shuts down. I suspect that freeing memory on the fly for the new kernel
would be non-trivial (but possible), however simply having a reserve
RAM region for the new kernel would be fine for a first step.

-- 
SUSE Labs, Novell Inc.
