Return-Path: <linux-kernel-owner+w=401wt.eu-S939655AbXFHXOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939655AbXFHXOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 19:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbXFHXOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 19:14:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40506 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbXFHXOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 19:14:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706061229.24486.jesse.barnes@intel.com>
	<m1wsygryw3.fsf@ebiederm.dsl.xmission.com>
	<200706071030.15317.jesse.barnes@intel.com>
Date: Fri, 08 Jun 2007 17:13:22 -0600
In-Reply-To: <200706071030.15317.jesse.barnes@intel.com> (Jesse Barnes's
	message of "Thu, 7 Jun 2007 10:30:14 -0700")
Message-ID: <m13b12rqel.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jesse.barnes@intel.com> writes:


>> - Overlapping MTRRs.
>
> Overlapping should be ok, since that's usually intentional (e.g. one big 
> wb range with a portion of uc space due to another mtrr).

I'm not say overlapping was a bug.  I was saying that you don't handle
overlapping mtrrs in figuring the last cached addresses.  Therefore
when a UC range overlaps a WB range we might thing the last page
in the WB range is cached when it is not.

>> - What happens if we have uncached memory lower down?
>
> Holes definitely aren't dealt with, but then we haven't seen any yet...
>
>>   Except for performance problems I guess that case is relatively
>> harmless. - Is it possible and worth it to amend the e820 map, so it
>> shows the problem area as Reserved or otherwise not usable RAM?
>
> That would be useful, but only if we moved the check to a little 
> earlier, prior to the addition of the active ranges from the e820.  
> Might be a little nicer than adjusting end_pfn, but will ultimately 
> achieve the same thing...

Yes, with perhaps a little more consistency.

Eric
