Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbXBFSFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbXBFSFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933173AbXBFSFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:05:34 -0500
Received: from mail.tmr.com ([64.65.253.246]:35237 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168AbXBFSFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:05:34 -0500
Message-ID: <45C8C2F3.2010905@tmr.com>
Date: Tue, 06 Feb 2007 13:03:31 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Theodore Tso <tytso@mit.edu>, David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
References: <1170711587.29759.909.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> <1170712393.29759.925.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> <20070205143110.fca62b57.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org> <1170717694.29759.941.camel@pmac.infradead.org> <20070206010958.GA31809@thunk.org> <20070206060937.GM16722@waste.org> <45C8A70F.9090507@tmr.com> <20070206164118.GP10108@waste.org>
In-Reply-To: <20070206164118.GP10108@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Tue, Feb 06, 2007 at 11:04:31AM -0500, Bill Davidsen wrote:
>   
>>> There's no reason we shouldn't be able to do exactly that with config
>>> symbols in Kconfig-land. The only difference is that we've got
>>> slightly different semantics for our "depend" keyword. Things which
>>> don't have their "depend" requirements met aren't offered as options.
>>> Whereas "select" is "automatically pull in dependencies"
>>> apt/yum-style.
>>>       
>> Perhaps this is because there is a lacking keyword. The depends controls 
>> visibility, perhaps a "requires" could be used to provide advisory 
>> information which mean "these other things will be turned on if you 
>> build this feature."
>>     
>
> "require" is a bad name as it's a synonym of "depend".
>
>   
>>> While we're at it, it would also be nice to be able to do:
>>>
>>> $ kconfig enable ACPI
>>> CONFIG_ACPI conflicts with CONFIG_APM
>>> $ kconfig enable -F ACPI
>>> disabling CONFIG_APM
>>> $ kconfig disable SCSI
>>> CONFIG_USB_STORAGE depends on CONFIG_SCSI
>>> $ kconfig disable -f SCSI
>>> disabling USB_STORAGE
>>> $ make
>>>
>>>       
>> I think depends and select provide this now, the postulated "requires" 
>> might make building the trees easier.
>>     
>
> The above is all about having a scriptable command line interface so
> that people don't need the broken sed + make oldconfig thing.
>
>   
I didn't say that clearly, I meant that the information to do this was 
present, not the functionality.

Someone suggested that 'requires' was a synonym of 'depends on' and was 
a bad choice. I think the requirement is in fasct the same, what I was 
after was not to prevent visibility of the option as 'depends' does. And 
we still probably need depends to avoid way too many choices.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

