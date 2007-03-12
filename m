Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbXCLSsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbXCLSsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXCLSsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:48:47 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1620 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbXCLSsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:48:46 -0400
Message-ID: <45F5A06D.4030004@shadowen.org>
Date: Mon, 12 Mar 2007 18:48:13 +0000
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Dave Hansen <hansendc@us.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/3] Lumpy Reclaim V4
References: <exportbomb.1173723760@pinky>	 <5239d2d31cd39bf4fc33426648f97be0@pinky> <1173724576.11945.100.camel@localhost.localdomain>
In-Reply-To: <1173724576.11945.100.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Mon, 2007-03-12 at 18:23 +0000, Andy Whitcroft wrote:
>> +                       /* The target page is in the block, ignore it. */
>> +                       if (unlikely(pfn == page_pfn))
>> +                               continue;
>> +#ifdef CONFIG_HOLES_IN_ZONE
>> +                       /* Avoid holes within the zone. */
>> +                       if (unlikely(!pfn_valid(pfn)))
>> +                               break;
>> +#endif 
> 
> Would having something like:
> 
>         static inline int pfn_in_zone_hole(unsigned long pfn)
>         {
>         #ifdef CONFIG_HOLES_IN_ZONE
>         	if (unlikely(!pfn_valid(pfn)))
>         		return 1;
>         #endif 
>         	return 0;
>         }
>         
> help us out?  page_is_buddy() and page_is_consistent() appear to do the
> exact same thing, with the same #ifdef.

Funny you mention that.  I have a patch hanging around which basically
does that.  I'd been planning to send it up.  It adds a
pfn_valid_within() which you use when you already know a relative page
within the MAX_ORDER block is valid.  I'd not sent it cause I thought
the name sucked.

-apw
