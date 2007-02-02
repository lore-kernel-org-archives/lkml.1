Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbXBBDQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbXBBDQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 22:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXBBDQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 22:16:05 -0500
Received: from terminus.zytor.com ([192.83.249.54]:37375 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbXBBDQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 22:16:03 -0500
Message-ID: <45C2ACEA.8020205@zytor.com>
Date: Thu, 01 Feb 2007 19:15:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Michael K. Edwards" <medwards.linux@gmail.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Should io(read|write)(8|16|32)_rep take (const|) volatile u(8|16|32)
 __iomem *addr?
References: <f2b55d220702011624v6cb13c8ct1d70863a661d2227@mail.gmail.com> <f2b55d220702011635s5b338a6ct861645ea7892f732@mail.gmail.com>
In-Reply-To: <f2b55d220702011635s5b338a6ct861645ea7892f732@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards wrote:
> 
> It looks to me, by comparison to memcpy_(from|to)io, as if the
> volatiles ought to be there.  It also looks to me like the void *
> parameters should be u(8|16|32) * instead, so the compiler knows what
> alignment to expect (the implementations would generally fail or suck
> on non-aligned arguments).  (That would also be more consistent with
> the fact that the length parameters are in (8|16|32)-bit units, not
> octets.)
> 
> Opinions?
> 

The real question is whether or not gcc does anything sane with "const 
volatile", which may incorrectly sound oxymoronic to some people (it's 
not, const means "this element must not be written to" and volatile 
means "reading or writing this element has side effects".)

I would argue the right thing to do is to do the patch assuming gcc is 
sane, and let it sit in -mm for a kernel cycle or two.

	-hpa
