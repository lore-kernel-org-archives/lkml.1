Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYH1Ua7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYH1Ua7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYH1Uat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:30:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60781 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYH1Uas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:30:48 -0400
Message-ID: <48B70ABC.8010805@zytor.com>
Date: Thu, 28 Aug 2008 13:29:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late
References: <1219952345-13574-1-git-send-email-yhlu.kernel@gmail.com> <alpine.LFD.1.10.0808281255200.3300@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808281255200.3300@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> So e820 is fairly trustworthy, but we know that it will have various 
> random things marked as reserved because they are special in some way (but 
> we don't know _how_ they are special - they may well be real BAR's that 
> just have a fixed meaning to ACPI or whatever).
> 

My thinking is that if we run into a region which is reserved in e820 
but points to a real BAR, we would want to keep that BAR pinned, since a 
legitimate BIOS might use this mechanism to indicate that the device 
implemented by that BAR is used by SMM or ACPI.  If not, in most cases 
we will only have wasted some address space.  The sucky case, of course, 
would be an uninitialized BAR pointing into unusable address space which 
happens to be reserved in e820.  This seems very difficult to 
disambiguate from the above case through any algorithm that I can think of.

> Of course, I bet there will be cases where this causes problems. It feels 
> like we have _never_ worked around some PCI BAR allocation problem without 
> hitting another unexpected one..

I suspect that for any possible behaviour, there will be at least one 
system out there doing something broken for it :(

	-hpa
