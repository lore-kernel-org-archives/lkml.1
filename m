Return-Path: <linux-kernel-owner+w=401wt.eu-S938007AbXHGWEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938007AbXHGWEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937616AbXHGVig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:38:36 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:41842 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937250AbXHGVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:38:34 -0400
Message-ID: <46B8E64E.7010708@nortel.com>
Date: Tue, 07 Aug 2007 15:38:22 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com> <46B8DDF3.7050008@nortel.com> <46B8E1D3.8050501@redhat.com>
In-Reply-To: <46B8E1D3.8050501@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2007 21:38:26.0098 (UTC) FILETIME=[4964A920:01C7D93B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:

> That's why we define atomic_read like so:
> 
> #define atomic_read(v)          ((v)->counter)
> 
> This avoids the aliasing problem, because the compiler must de-reference 
> the pointer every time, which requires a memory fetch.

Can you guarantee that the pointer dereference cannot be optimised away 
on any architecture?  Without other restrictions, a suficiently 
intelligent optimiser could notice that the address of v doesn't change 
in the loop and the destination is never written within the loop, so the 
read could be hoisted out of the loop.

Even now, powerpc (as an example) defines atomic_t as:

typedef struct { volatile int counter; } atomic_t


That volatile is there precisely to force the compiler to dereference it 
every single time.

Chris
