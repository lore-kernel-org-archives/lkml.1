Return-Path: <linux-kernel-owner+w=401wt.eu-S1762400AbYFFHOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762400AbYFFHOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYFFHOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:14:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13325 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYFFHOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:14:05 -0400
Message-Id: <48490005.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 06 Jun 2008 08:14:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Stable Kernel" <stable@kernel.org>,
       <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
References: <4848046A.5060006@goop.org><4848046A.5060006@goop.org> (Jeremy
 Fitzhardinge's message of "Thu, 05 Jun 2008 16:21:14 +0100")
 <87ve0ntk6v.fsf@basil.nowhere.org>
In-Reply-To: <87ve0ntk6v.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 06.06.08 03:40 >>>
>Jeremy Fitzhardinge <jeremy@goop.org> writes:
>>
>> The 46-bit mask used in 64-bit seems pretty arbitrary. 
>
>The rationale for the 46 bits is that the kernel needs roughly 4x as 
>much virtual space as physical space and the virtual space is limited
>to 48bits.
>
>To be exact 47 bits is always user space and the 47 bits remaining
>for the kernel are split into half, with one half for the direct mapping
>and the other half for random mappings.  With some pushing you could
>extend it to 46.5 bits or so, but beyond that you'll be in trouble.
>
>It's not arbitrary at all.

That is only half of it. Since PHYSICAL_MASK also controls other than
RAM mappings, there's really two constants that are needed here:
One (46) to indicate how large the 1:1 mapping can possibly get (and
hence what the upper boundary of usable RAM is - without introducing
highmem), and another (52) to indicate how wide a physical address
(perhaps from a 64-bit PCI BAR) can possibly be (i.e. used to validate
physical addresses / page table entries).

Jan

