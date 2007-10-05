Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbXJEJPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbXJEJPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 05:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbXJEJPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 05:15:11 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:6817 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754114AbXJEJPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:15:09 -0400
User-Agent: Microsoft-Entourage/11.3.6.070618
Date: Fri, 05 Oct 2007 10:15:03 +0100
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
From: Keir Fraser <keir@xensource.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickens <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <C32BBF27.166CA%keir@xensource.com>
Thread-Topic: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
Thread-Index: AcgHMDY/dRMC13MjEdyzowAX8io7RQ==
In-Reply-To: <4705FE5C.4060807@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07 10:05, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> Andi says:
>> Do I misread that patch or does it really walk the complete address
>> space and try to take all possible locks? Isn't that very slow?
>>   
> 
> That's pretty much what it has to do.  Pinning/unpinning walks the whole
> pagetable anyway, so it shouldn't be much more expensive.  And they're
> relatively rare operations (fork, exec, exit).

It is a shame to do 3x walks per pin or unpin, rather than 1x, though.

One way to improve this, possibly, is to pin the pte tables individually as
you go, rather than doing one big pin/unpin just at the root pgd. Then you
can lock/unlock the pte's as you go. I'd suggest that as a possible post
2.6.23 improvement, however. Jan's patch has actually had some testing.

 -- Keir

