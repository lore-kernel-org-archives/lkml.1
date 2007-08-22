Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbXHVO0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbXHVO0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760535AbXHVOZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:25:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:41771 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758711AbXHVOZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:25:54 -0400
In-Reply-To: <46CC42EF.3030602@redhat.com>
References: <46C03885.7000109@redhat.com> <20070813112452.GK24018@shell.boston.redhat.com> <swfhcmswcux.wl%takata.hirokazu@renesas.com> <swfejhww4cs.wl%takata.hirokazu@renesas.com> <46CC42EF.3030602@redhat.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <8fc86c23579e12b012891d6e69b1b107@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Hirokazu Takata <takata@linux-m32r.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       Chris Friesen <cfriesen@nortel.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 11/23] make atomic_read() and atomic_set() behavior consistent on m32r
Date: Wed, 22 Aug 2007 16:24:11 +0200
To: Chris Snook <csnook@redhat.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> I also tried to rewrite it with inline asm code, but the kernel text 
>> size
>> bacame roughly 2kB larger. So, I prefer C version.

Could you send me the source code diff between the two versions
you tested?  2kB difference is way too much, the asm version should
be smaller if anything.

> You're not the only arch maintainer who prefers doing it in C.  If you 
> trust your compiler (a big "if", apparently), inline asm only improves 
> code generation if you have a whole bunch of general purpose registers 
> for the optimizer to play with.

No.  The only real difference between the *(volatile *)& version
and the volatile asm() version is that the volatile asm() version
has defined semantics.  There will be some code generation differences
too, but they should be in the noise, unless GCC generates really
bad code for either case.  We know it sometimes does that for the
*(volatile *)& thing; if the asm() version does something bad, I'd
like to know about that too.


Segher

