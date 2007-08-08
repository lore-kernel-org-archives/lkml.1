Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbXHHGs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbXHHGs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXHHGsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:48:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbXHHGsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:48:16 -0400
Message-ID: <46B96719.3050006@redhat.com>
Date: Wed, 08 Aug 2007 02:47:53 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Zan Lynx <zlynx@acm.org>, Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com> <46B8DDF3.7050008@nortel.com> <46B8E1D3.8050501@redhat.com>  <46B8E64E.7010708@nortel.com> <1186525977.232321.43.camel@localhost> <46B91D0C.5050704@redhat.com> <46B94B94.6000600@nortel.com>
In-Reply-To: <46B94B94.6000600@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Chris Snook wrote:
> 
>> This is not a problem, since indirect references will cause the CPU to 
>> fetch the data from memory/cache anyway.
> 
> Isn't Zan's sample code (that shows the problem) already using indirect 
> references?

Yeah, I misinterpreted his conclusion.  I thought about this for a 
while, and realized that it's perfectly legal for the compiler to re-use 
a value obtained from atomic_read.  All that matters is that the read 
itself was atomic.  The use (or non-use) of the volatile keyword is 
really more relevant to the other atomic operations.  If you want to 
guarantee a re-read from memory, use barrier().  This, incidentally, 
uses volatile under the hood.

	-- Chris
