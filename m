Return-Path: <linux-kernel-owner+w=401wt.eu-S1762840AbXHVOHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762840AbXHVOHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbXHVOHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:07:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbXHVOHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:07:10 -0400
Message-ID: <46CC42EF.3030602@redhat.com>
Date: Wed, 22 Aug 2007 10:06:39 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Hirokazu Takata <takata@linux-m32r.org>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 11/23] make atomic_read() and atomic_set() behavior consistent
 on m32r
References: <46C03885.7000109@redhat.com> <20070813112452.GK24018@shell.boston.redhat.com> <swfhcmswcux.wl%takata.hirokazu@renesas.com> <swfejhww4cs.wl%takata.hirokazu@renesas.com>
In-Reply-To: <swfejhww4cs.wl%takata.hirokazu@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hirokazu Takata wrote:
> I think the parameter of atomic_read() should have "const" 
> qualifier to avoid these warnings, and IMHO this modification might be
> worth applying on other archs.

I agree.

> Here is an additional patch to revise the previous one for m32r.

I'll incorporate this change if we get enough consensus to justify a 
re-re-re-submit.  Since the patch is intended to be a functional no-op on m32r, 
I'm inclined to leave it alone at the moment.

> I also tried to rewrite it with inline asm code, but the kernel text size
> bacame roughly 2kB larger. So, I prefer C version.

You're not the only arch maintainer who prefers doing it in C.  If you trust 
your compiler (a big "if", apparently), inline asm only improves code generation 
if you have a whole bunch of general purpose registers for the optimizer to play 
with.

	-- Chris
