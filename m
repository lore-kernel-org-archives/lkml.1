Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZEMWkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZEMWkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZEMWj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:39:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37138 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbZEMWj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:39:56 -0400
Message-ID: <4A0B4C1C.9000706@garzik.org>
Date: Wed, 13 May 2009 18:39:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	 <20090421.173123.191021055.davem@davemloft.net>	 <adak55438gp.fsf_-_@cisco.com>	 <20090428.221228.217954247.davem@davemloft.net>	 <20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>	 <adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org> <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com> <4A0B2B54.5090803@zytor.com>
In-Reply-To: <4A0B2B54.5090803@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> #include <linux/io64_lh.h>
> 
> linux/io64_lh.h would then look like:
> 
> #ifndef _LINUX_IO64_LH_H
> #define _LINUX_IO64_LH_H
> 
> #include <linux/io.h>
> 
> #ifndef HAVE_READQ
> 
> /* Low-High nonatomic readq() */
> 
> #endif
> 
> #ifndef HAVE_WRITEQ
> 
> /* Low-High nonatomic writeq() */


Judging from this thread and past, I think people will continue to 
complain and get confused, even with the above.

How about

1) tree-wide rename: readq -> readq_na, writeq -> writeq_na

2) make all PCI writel-enabled arches provide readq_na and writeq_na

3) 64-bit PCI writel-enabled arches provide readq and HAVE_READQ, ditto 
for writeq.  32-bit provides neither readq nor HAVE_READQ.

4) If your hardware has non-standard ordering, handle it the obvious way 
in the driver, as you would do with any other special case.

	Jeff



P.S. I use "writel-enabled" to note that some platforms do not provide 
PCI read*/write* functions at all.

