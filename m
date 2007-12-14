Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbXLNIiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbXLNIiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXLNIiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:38:00 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:29699
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbXLNIiA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:38:00 -0500
Message-Id: <47624F26.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 14 Dec 2007 08:38:46 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <tglx@linutronix.de>, <mingo@redhat.com>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix ref-counting bug in change_page_attr()
References: <47610AB5.76E4.0078.0@novell.com> <47622CC5.3060903@goop.org>
In-Reply-To: <47622CC5.3060903@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 14.12.07 08:12 >>>
>Jan Beulich wrote:
>> When either calling change_page_attr() with the default attributes
>> pages in the direct mapping have and a page's attributes already were
>> set to the default or when changing the attributes from one non-default
>> value to another, the reference counting broke, leading to either
>> premature restoration of a large page or missing the opportunity to do
>> so.
>>
>> At the same time, make __PHYSICAL_MASK_SHIFT on 64-bits the value it
>> architecturally ought to have.
>>   
>
>Could you put this in a separate patch?  I have a bunch of page*.h and
>pgtable*.h refactoring patches which will conflict with this.

I doesn't seem logical to do so: The patch needs to introduce the definitions
for 32-bits (in order to define pte_pgprot()), and not doing the adjustment
for 64-bits here means (a) becoming inconsistent and (b) the pte_pgprot()
there would be incorrect. So such a split out patch would need to be a pre-
requisite to the one here, which wouldn't help avoiding the collisions with
your unification patches.

Jan

