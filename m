Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYANIVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYANIVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYANIVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:21:40 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:1542
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbYANIVj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:21:39 -0500
Message-Id: <478B29BE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 14 Jan 2008 08:22:06 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@xensource.com>
Subject: Re: [PATCH] adjust/fix LDT handling for Xen
References: <4787436E.76E4.0078.0@novell.com> <4787A72E.8060704@citrix.com>
In-Reply-To: <4787A72E.8060704@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com> 11.01.08 18:28 >>>
>Jan Beulich wrote:
>> Don't rely on kmalloc(PAGE_SIZE) returning PAGE_SIZE aligned memory
>> (Xen requires GDT *and* LDT to be page-aligned).
>
>Can kmalloc return non-page-aligned PAGE_SIZE allocations?

Documentation says it's to return pointer-size aligned memory - any excess
alignment is therefore an implementation detail. (Nevertheless, afaics all
current allocators generate page-aligned chunks.)

>>  Using the page
>> allocator interface also removes the (albeit small) slab allocator
>> overhead.
>
>Runtime or space overhead?  Given that they're once-off allocations, the 
>time part isn't a big factor.  And apparently LDT is completely unused.

Both, but as I also said the saving is small.

Jan

