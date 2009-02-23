Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZBWO5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZBWO5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZBWO46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:56:58 -0500
Received: from cathcart.site5.com ([74.54.107.137]:37935 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZBWO46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:56:58 -0500
Message-ID: <49A2B936.5070801@compulab.co.il>
Date: Mon, 23 Feb 2009 16:56:54 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch --file warns about p0 patch
References: <49A2B0A5.8050905@compulab.co.il> <20090223144312.GC22617@shadowen.org>
In-Reply-To: <20090223144312.GC22617@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andy Whitcroft wrote:
> On Mon, Feb 23, 2009 at 04:20:21PM +0200, Mike Rapoport wrote:
>> When running checkpatch.pl with --file option it warns about -p0 patch:
>>
>> ./scripts/checkpatch.pl --file ./drivers/rtc/rtc-v3020.c
>> WARNING: patch prefix '.' exists, appears to be a -p0 patch
>>
>> total: 0 errors, 1 warnings, 263 lines checked
>>
>> ./drivers/rtc/rtc-v3020.c has style problems, please review.  If any of these errors
>> are false positives report them to the maintainer, see
>> CHECKPATCH in MAINTAINERS.
>>
>> I hope this is the fix that'll work:
>>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index 45eb0ae..1869388 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -1240,7 +1240,7 @@ sub process {
>>  			$realfile =~ s@^([^/]*)/@@;
>>
>>  			$p1_prefix = $1;
>> -			if ($tree && $p1_prefix ne '' && -e "$root/$p1_prefix") {
>> +			if (!$file && $tree && $p1_prefix ne '' && -e "$root/$p1_prefix") {
>>  				WARN("patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
>>  			}
>>
>>
>>
>> -- 
> 
> Hmm, that should already be fixed in the version Andrew Morton has.

I've run the version from Linus tree.

> Could you test with v0.28 and confirm its already fixed?

v0.28 works Ok.

> 
>   http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-v0.28
> 
> -apw
> 

-- 
Sincerely yours,
Mike.

