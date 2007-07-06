Return-Path: <linux-kernel-owner+w=401wt.eu-S1764088AbXGFUnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764088AbXGFUnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761901AbXGFUno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:43:44 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43197 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761125AbXGFUnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:43:42 -0400
Message-ID: <468EA74D.7010706@vmware.com>
Date: Fri, 06 Jul 2007 13:34:21 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] VMI: remove CONFIG_DEBUG_PAGE_TYPE and associated	bitrotted
 code
References: <Pine.LNX.4.64.0707060847470.23786@localhost.localdomain>	<468E890A.1070504@s5r6.in-berlin.de>	<20070706201625.GT4306@sequoia.sous-sol.org> <468EA27C.9060401@vmware.com> <468EA5E0.4070501@goop.org>
In-Reply-To: <468EA5E0.4070501@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> I never merged the whole bit upstream because it added a field to 
>> struct page. 
>
> Hm, is that a big problem?  It would be OK for a debug config option, 
> wouldn't it?  Also, it doesn't seem particularly vmi-specific.  Could 
> it be made part of the pvops infrastructure?

I though about it, but it gets really ugly.  You need wrappers for all 
the MMU ops in pvops generic code, which means either another layer of 
wrappers or a bunch of CONFIG_DEBUG_PARAVIRT only things that are easy 
to break because they also depend on PAE vs. non-PAE.

It's doable, though, and might even be extensible to s390 for CMM page 
type debugging, as well as descriptor type tracking and enforcement of 
page isolation of GDTs.

Page state tracking could track -

PAGE_ZERO, PAGE_UNUSED, PAGE_STABLE, PAGE_VOLATILE, 
PAGE_POTENTIALLY_VOLATILE, PAGE_L1{2/3/4}, PAGE_LDT, PAGE_GDT,

actually, no this seems silly, since we'd just be duplicating bits for 
the page types, so the only debug benefit is ensuring the intersection 
of volatile and L{1/2/3/4} is nil, which is already trivially verifiable 
by inspection.

Zach
