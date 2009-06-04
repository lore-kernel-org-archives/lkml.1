Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbZFDRDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbZFDRDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZFDRDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:03:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbZFDRDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:03:25 -0400
Date: Thu, 4 Jun 2009 10:03:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Michael S. Zick" <lkml@morethan.org>
cc: Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
In-Reply-To: <200906041121.30845.lkml@morethan.org>
Message-ID: <alpine.LFD.2.01.0906040948480.4880@localhost.localdomain>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com> <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain> <200906041121.30845.lkml@morethan.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Jun 2009, Michael S. Zick wrote:
> 
> The C7-M processor uses "in-order retirement" not "out-of-order" - -
> I think the MCR's **should not** be set for "weak ordered writes" -

In-order retirement does not really imply anything at all about how write 
ordering works out. In most CPU parlance, you'd say that you've "retired" 
a write instruction when it has completed in the write queue - but it 
would not mean anything in particular for memory ordering.

Of course, I don't think the C7 is just in-order retirement, I think it's 
pretty much in-order everything. Usually you only specify that 
"retirement" part when there is some out-of-order execution in other parts 
of the pipeline, but I think the C7 is entirely in-order pipeline, 
although I suspect the FPU side is likely somewhat separated.

But still, with a write buffer (and _no_ sane x86 does not have a write 
buffer), that doesn't actually mean that the cache and memory accesses are 
necessarily entirely in-order.

That said, how all the internal CPU registers are set is all black magic. 

			Linus
