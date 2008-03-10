Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYCJCp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYCJCp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 22:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbYCJCpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 22:45:52 -0400
Received: from gw.goop.org ([64.81.55.164]:55531 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYCJCpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 22:45:51 -0400
Message-ID: <47D4A0B7.10905@goop.org>
Date: Sun, 09 Mar 2008 19:45:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       hans.rosenfeld@amd.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com> <alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org> <20080309115603.GA951@elte.hu> <alpine.LFD.1.00.0803091007560.5896@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803091007560.5896@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So I would *very* strongly instead argue:
>
>  - "unsigned long" is the native kernel type for all address manipulation, 
>    and thus "PAGE_SIZE" and "PAGE_MASK" should continue to have that type.
>
>  - anything that uses any other type without explicitly making sure it's 
>    safe is mis-using those macros. IOW, PAGE_MASk was *never* a type that 
>    had anything what-so-ever to do with page table entry bits, and this is 
>    purely a page table entry issue!
>   

Yes.  PTE_MASK already exists for masking the address bits out of a 
pte.  It should have the type pteval_t, which will deal with the PAE 
case cleanly.  It should also only have the middle pfn bits set, so that 
_PAGE_NX is also not included.

It's currently defined in terms of PHYSICAL_PAGE_MASK, which 1) is only 
used to define PTE_MASK, and 2) defined (wrongly) in terms of PAGE_MASK 
(though __PHYSICAL_MASK is correctly defined).

    J
