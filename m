Return-Path: <linux-kernel-owner+w=401wt.eu-S1946134AbXBBVkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946134AbXBBVkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946133AbXBBVkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:40:14 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52295 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946134AbXBBVkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:40:13 -0500
Message-ID: <45C3AFB7.80207@garzik.org>
Date: Fri, 02 Feb 2007 16:40:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Michael K. Edwards" <medwards.linux@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Should io(read|write)(8|16|32)_rep take (const|) volatile u(8|16|32)
 __iomem *addr?
References: <f2b55d220702011624v6cb13c8ct1d70863a661d2227@mail.gmail.com>	 <f2b55d220702011635s5b338a6ct861645ea7892f732@mail.gmail.com>	 <45C2D47A.9080001@garzik.org> <45C2DA8D.4050007@zytor.com>	 <45C31B86.6070009@garzik.org> <f2b55d220702021158k7e0ce690xaba95394ee01e4e4@mail.gmail.com>
In-Reply-To: <f2b55d220702021158k7e0ce690xaba95394ee01e4e4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards wrote:
> Doubtless this is on purpose, but it's not clear to me why that should
> be true for these particular functions/macros.  I shouldn't have to
> cast away the volatile on a pointer to hardware registers in order to
> pass it into writel(), should I?  And it shouldn't be forbidden for
> the caller to declare the pointer volatile so that the compiler
> catches attempts to pass it into non-volatile interfaces, should it?


Therein lies your bug:  you should not be annotating your __iomem 
pointers with volatile.

That's why volatile is found in the implementation and not the 
prototypes of the accessor functions.

	Jeff


