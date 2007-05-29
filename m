Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbXE2JFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbXE2JFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXE2JFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:05:31 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2091 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXE2JFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:05:31 -0400
Message-ID: <465BECCC.5030001@shadowen.org>
Date: Tue, 29 May 2007 10:05:16 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de>
In-Reply-To: <p738xb8fjv2.fsf@bingen.suse.de>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Andy Whitcroft <apw@shadowen.org> writes:
>> +
>> +# no BUG() or BUG_ON()
>> +		if ($line =~ /\b(BUG|BUG_ON)\b/) {
>> +			print "Try to use WARN_ON & Recovery code rather than BUG() or BUG_ON()\n";
> 
> Just outlawing BUG_ON doesn't seem like a good idea to me. We'll just end
> up with lots of untested and likely buggy recovery code or no asserts. Both
> would be bad.

Thats not an unreasonable position.  And I tend to agree with it.
Either we try and have two levels Warnings and Errors, or we just drop
this one for now.

Anyone got an oppinion, so we can get a consensus.

>> +#need space before brace following if, while, etc
>> +		if($line=~/\(.*\){/) {
>> +			print ("need a space before the brace\n");
>> +			print "$herecurr";
>> +			$clean = 0;		
>> +		}
>> +
>> +#gotos aren't indented
> 
> You mean goto labels? Surely goto statements are to be indented.
> Confusing message

Yes, changed to labels

>> +		if($line=~/^\s*[A-Za-z\d_]+:/ and !($line=~/^\s*default:/)){
>> +			print "Gotos should not be indented\n";
>> +			print "$herecurr";
>> +			$clean = 0;
>> +		}
> 
> emacs generates one space label in front of a goto label. I wouldn't
> outlaw this.

Yep, we also now allow one space something to do with diff -p not
getting confused...

>> +# don't include <linux/video_decoder.h>
> 
> It would be probably better to define some syntax that makes it possible
> to auto extract those from feature-removal-schedule.txt. Otherwise
> long term this will become messy.

Yeah, that is a very sensible idea.

> Possible further checks that might make sense:
> - panic() anywhere in drivers/* 
> - externs in .c files without asmlinkage
> - general checking that everything in a fully visible {} block is the right 
> indentation
> 
> -Andi

Thanks.

-apw
