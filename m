Return-Path: <linux-kernel-owner+w=401wt.eu-S1763550AbYDVVGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763550AbYDVVGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbYDVVGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:06:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756744AbYDVVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:06:07 -0400
Date: Tue, 22 Apr 2008 14:05:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mfd: kconfig exposing unbuildable driver
In-Reply-To: <20080422203334.GA9809@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0804221359360.2779@woody.linux-foundation.org>
References: <1208895950.24124.9.camel@brick> <20080422203334.GA9809@flint.arm.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Russell King wrote:
>
> That was my initial approach as well, which got shot down by Andrew
> Morton and others as being unacceptable.

Hmm. While I in general support the notion of trying to compile drivers on 
as wide a variety as hardware as possible, if that HTC_PASIC3 thing really 
is a PXA-only piece of hardware, I don't really see the point of not 
making the config file accurately represent that.

That said, as far as I can tell, the compile failure is because of this 
line:

	#include <asm/arch/pxa-regs.h>

and I cannot for the life of me see _why_ it tries to include that header 
file. It seems to compile fine on x96-64 if you just remove that include, 
and while I still think it should depend on ARCH_PXA just because it makes 
no sense _not_ to, I do wonder why that include is there in the first 
place.

Hmm?

		Linus
