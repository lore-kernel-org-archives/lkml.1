Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbYKGJxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbYKGJxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKGJxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:53:23 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:5639 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbYKGJxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:53:22 -0500
Message-Id: <49141E3B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 07 Nov 2008 09:53:47 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ian Campbell" <Ian.Campbell@citrix.com>,
       "xen devel" <xen-devel@lists.xensource.com>,
       "Christopher S. Aker" <caker@theshore.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] 2.6.27 - SMP enabled, but only 1 CPU
References: <48F3BC99.5040409@theshore.net> <490F5F50.7020704@theshore.net>
 <4910AD00.7040605@theshore.net> <4911BC52.7040905@theshore.net>
 <1225994697.12607.837.camel@zakaz.uk.xensource.com>
 <49134257.4000404@goop.org> <20081106211639.GA24579@elte.hu>
 <49136168.3040604@goop.org> <20081106213344.GF24579@elte.hu>
 <49136628.1020000@goop.org> <20081106222039.GA7505@elte.hu>
In-Reply-To: <20081106222039.GA7505@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 06.11.08 23:20 >>>
>
>* Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> Ingo Molnar wrote:
>>> where exactly is that use? My grep didnt show any users of pud_page().  
>>> pud_page() was changed in an incompatible way, all users of it must be  
>>> updated.
>>>   
>>
>> pgd_page() uses it in pgtable-nopud.h, so any users of pgd_page() 
>> also need to be looked at.  It so happens the only user is 
>> arch/x86/xen/mmu.c, which expects it to return the vaddr.  Fixed 
>> below.
>
>ah! asm-generic was missed by my grep. (and i suspect Jan missed it 
>too)

Indeed - broken as it was I never even considered this could be used
somewhere in generic code.

>> Subject: xen: fix use of pgd_page now that it really does return a page
>
>applied to tip/x86/urgent, thanks!

And my thanks, too, Jeremy, for the quick spotting of the problem.

Jan

