Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZA1WOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZA1WOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZA1WOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:14:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbZA1WOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:14:31 -0500
Date: Wed, 28 Jan 2009 14:13:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
In-Reply-To: <1233179884.6717.59.camel@brick>
Message-ID: <alpine.LFD.2.00.0901281411490.3123@localhost.localdomain>
References: <20090127222825.GA27097@elte.hu>  <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>  <1233106614.3256.6.camel@localhost.localdomain>  <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>  <1233170532.6717.49.camel@brick> 
 <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>  <1233172994.6717.56.camel@brick>  <4980CD51.70601@zytor.com> <1233179884.6717.59.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Jan 2009, Harvey Harrison wrote:
>
> Use ifdef __i486__ to ensure the BSWAP instruction is available
> on 32-bit x86.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> HPA,
> 
> I'm afraid my knowledge of gcc compiler flags for various models is
> lacking, I used i486 as suggested, just wanted to make sure I understood
> you corectly.

I really don't think this works.

Try this:

	cpp -dM -m32 -march=pentium t.c | grep i486

and see the marked absense of __i486__ anywhere.

At least CONFIG_X86_BSWAP gives the right behaviour for the kernel.

			Linus
