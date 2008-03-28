Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYC1LVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYC1LVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYC1LVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:21:44 -0400
Received: from omega.artcom.pl ([194.6.246.15]:35079 "EHLO omega.artcom.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbYC1LVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:21:43 -0400
X-Greylist: delayed 1953 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2008 07:21:43 EDT
Message-ID: <47ECCD17.7080908@artcom.pl>
Date: Fri, 28 Mar 2008 11:48:55 +0100
From: =?UTF-8?B?UGF3ZcWCIFN0YXN6ZXdza2k=?= <pstaszewski@artcom.pl>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com> <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds pisze:
> On Thu, 27 Mar 2008, Christoph Lameter wrote:
>   
>> Slab allocations can never use GFP_HIGHMEM.
>>     
>
> Totally irrelevant.
>
> The page allocation path does
>
>         if (gfp_flags & __GFP_ZERO)
>                 prep_zero_page(page, order, gfp_flags);
>
> and that will cause a warning REGARDLESS of whether the page is a HIGHMEM 
> page or not.
>
> And the fact is, passing in GFP_ZERO from the SLUB code is a bug 
> regardless, because it unnecessarily does the dual memset().
>
> So here's a damn big clue:
>  - SLUB does its own GFP_ZERO handling
>  - so passing GFP_ZERO down to the page allocator is a f*cking bug
>  - and this has NOTHING what-so-ever to do with GFP_HIGHMEM or even 
>    whether the warning is "valid" or not - it's a bug even if the warning 
>    had never happened.
>
> So stop blathering, and just admit that this was buggy. It was also 
> fundamentally fragile to leave GFP_ZERO around when it was known to not be 
> valid at that point (exactly because GFP_ZERO was handled by the caller).
>
> 		Linus
>
>
>   
Sorry for offtopic but i have the same problem with kernels 2.6.25-*
like:
http://kerneltrap.org/mailarchive/linux-netdev/2008/3/27/1274804
http://kerneltrap.org/mailarchive/linux-netdev/2008/3/27/1270334

I search linux-netdev and found this links.
I only sugest that 

	Denys Fedoryshchenko

can have the same problem that i have with this kernels.
I must revert my all kernels to 2.6.23.11 to get stable work on high (ip 
traffic) loads.

And there is no documentation for LRO... and Stephen Hemminger write me 
that LRO is not compatible with bridgeing and routing.
see this link:
http://bugzilla.kernel.org/show_bug.cgi?id=10335


So there must be some documentation for this ... because people can have 
many problems with this.


Sorry for offtopic but this can resolve problems like my and Denys .

Pawel

