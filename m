Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbZGCTTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbZGCTTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbZGCTTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:19:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758803AbZGCTTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:19:24 -0400
Message-ID: <4A4E58AC.7010905@zytor.com>
Date: Fri, 03 Jul 2009 12:14:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
References: <200907031314.36243.lkml@morethan.org> <4A4E54A8.4030606@goop.org> <200907031403.34566.lkml@morethan.org>
In-Reply-To: <200907031403.34566.lkml@morethan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
>>
>> The PGTABLE reservation seems much too big.  I think 1 page should be
>> sufficient for a system with large pages.  Even if not, 0x6d000 is way
>> too large.  And they symptoms of failing to reserve the initial
>> pagetable are pretty non-subtle.
>>
> 
> Random system halts, deadlocks with interrupts disabled?
> Yup, that sounds familiar.
> 
> If I ever get more than a stopped machine with a glowing power light;
> I will be certain to share.
> 

Let's see... on a non-PSE system we may need one PDE and one PTE page
per 4 MB, up to 1 GB, for a total of 256 pages or 1 MB of memory, so in
that sense 0x6d000 (109 pages) doesn't sound at all unreasonable
(non-PSE system with 512 MB of RAM?)

However, we shouldn't have to do this kind of hacks with
MAPPING_BEYOND_END, and we *certainly* shouldn't do it by implicitly
hard-coding the value of PAGE_SHIFT.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

