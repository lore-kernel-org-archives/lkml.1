Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbXFVILP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbXFVILP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 04:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXFVILA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 04:11:00 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:43682 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbXFVIK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 04:10:58 -0400
Message-ID: <467B840F.4080402@dgreaves.com>
Date: Fri, 22 Jun 2007 09:10:55 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>	<18034.479.256870.600360@notabene.brown>	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>	<18034.3676.477575.490448@notabene.brown>	<46756BE2.7010401@tmr.com>	<467B03C1.50809@tmr.com> <18043.13037.40956.366334@notabene.brown>
In-Reply-To: <18043.13037.40956.366334@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Thursday June 21, davidsen@tmr.com wrote:
>> I didn't get a comment on my suggestion for a quick and dirty fix for 
>> -assume-clean issues...
>>
>> Bill Davidsen wrote:
>>> How about a simple solution which would get an array on line and still 
>>> be safe? All it would take is a flag which forced reconstruct writes 
>>> for RAID-5. You could set it with an option, or automatically if 
>>> someone puts --assume-clean with --create, leave it in the superblock 
>>> until the first "repair" runs to completion. And for repair you could 
>>> make some assumptions about bad parity not being caused by error but 
>>> just unwritten.
> 
> It is certainly possible, and probably not a lot of effort.  I'm not
> really excited about it though.
> 
> So if someone to submit a patch that did the right stuff,  I would
> probably accept it, but I am unlikely to do it myself.
> 
> 
>>> Thought 2: I think the unwritten bit is easier than you think, you 
>>> only need it on parity blocks for RAID5, not on data blocks. When a 
>>> write is done, if the bit is set do a reconstruct, write the parity 
>>> block, and clear the bit. Keeping a bit per data block is madness, and 
>>> appears to be unnecessary as well.
> 
> Where do you propose storing those bits?  And how many would you cache
> in memory?  And what performance hit would you suffer for accessing
> them?  And would it be worth it?

Sometimes I think one of the problems with Linux is that it tries to do 
everything for everyone.

That's not a bad thing - until you look at the complexity it brings - and then 
consider the impact and exceptions when you do, eg hardware acceleration? md 
information fed up to the fs layer for xfs? simple long term maintenance?

Often these problems are well worth the benefits of the feature.

I _wonder_ if this is one where the right thing is to "just say no" :)

David
