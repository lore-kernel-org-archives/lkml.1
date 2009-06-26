Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZFZDVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZFZDVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 23:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZFZDVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 23:21:25 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:58177 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752443AbZFZDVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 23:21:24 -0400
Message-ID: <4A443EB5.40300@snapgear.com>
Date: Fri, 26 Jun 2009 13:21:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [uClinux-dev] 	Coldfire 5271 hitting BUG_ON(page_count(buddy)
 != 0);
References: <20090625154343.GA10189@csclub.uwaterloo.ca>
In-Reply-To: <20090625154343.GA10189@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lennart,

Lennart Sorensen wrote:
> I am hitting a memory management bug and I would love some hints as to
> how to track down the bug and fix it.
> 
> The bug hit is line 423 of page_alloc.c which is:
> 
> BUG_ON(page_count(buddy) != 0);
> 
> The function it is part of is:
> 
> static inline int page_is_buddy(struct page *page, struct page *buddy,
>                                                                 int order)
> {
>         if (!pfn_valid_within(page_to_pfn(buddy)))
>                 return 0;
> 
>         if (page_zone_id(page) != page_zone_id(buddy))
>                 return 0;
> 
>         if (PageBuddy(buddy) && page_order(buddy) == order) {
>                 BUG_ON(page_count(buddy) != 0);
>                 return 1;
>         }
>         return 0;
> }
> 
> I am seeing this both with 2.6.29.1 and 2.6.30 so far.  I unfortunately
> haven't poked much at the memory management code, so I am not even sure
> what this is supposed to be doing.  The cpu us a coldfire 5271.
> 
> I also see crashes causing the kernel to dump lots of hex values.
> Building the kernel with debug enabled unfortunately seems to move things
> around enough to make it just lock up instead without any output.

What are you doing at the time you get this?
Or is it at bootup?

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
