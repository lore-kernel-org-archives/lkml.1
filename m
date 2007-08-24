Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbXHXRSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbXHXRSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbXHXRSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:18:42 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40150 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbXHXRSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:18:41 -0400
Message-ID: <46CF12BF.7000705@oracle.com>
Date: Fri, 24 Aug 2007 10:17:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Paolo Giarrusso <blaisorblade@yahoo.it>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rpjday@mindspring.com
Subject: Re: [PATCH] Script to check for undefined Kconfig symbols - v2
References: <538193.69286.qm@web25220.mail.ukl.yahoo.com>
In-Reply-To: <538193.69286.qm@web25220.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Giarrusso wrote:
> On Fri, 24 Aug 2007 Randy Dunlap wrote:
>> On Fri, 24 Aug 2007 16:56:49 +0200 Paolo 'Blaisorblade' Giarrusso wrote:
>>
>>> In this version, I've updated the scripts to search for "\<$symb_bare\>" instead
>>> of $symb_bare in Kconfig files. Please ignore my previous message.
>>>
>>> To avoid to look manually for used but undefined Kconfig variables, I've
>>> written a script which tries do this efficiently, in case all other attention
>>> fail. It accounts for _MODULE suffix and for UML_ prefixes to Kconfig variable,
>>> but otherwise looks for exact matches (i.e. \<CONFIG_; this is done to exclude
>>> macros like MMCONFIG_).
>>>
>>> Undefined Kconfig variables should be not be removed without care, but for
>>> instance arch/i386/boot/ uses a bunch of undefined Kconfig vars:
>>>
>>> $ scripts/checkunknowndefines.sh arch/i386/boot/
>>> arch/i386/boot/video.h uses undefined symbol VIDEO_400_HACK
>>> arch/i386/boot/video-vga.c uses undefined symbol VIDEO_400_HACK
>>> arch/i386/boot/video.c uses undefined symbol VIDEO_RETAIN
>>> arch/i386/boot/video.h uses undefined symbol VIDEO_RETAIN
>>> arch/i386/boot/video.h uses undefined symbol VIDEO_SVGA
>>> arch/i386/boot/video.h uses undefined symbol VIDEO_VESA
>>> arch/i386/boot/video-vesa.c uses undefined symbol VIDEO_VESA
>>>
>>> Hope you can merge this in -mm and use it frequently (probably, a script to look for
>>> regressions in its output is useful). It should also be mentioned in
>>> SubmittingPatches if you agree.
>> or added to Documentation/SubmitChecklist.
> 
> Indeed - that's what I should have written, but I had forgot the exact file name.
> 
>> How does this script compare to
>> http://www.fsdev.net/wiki/index.php?title=Misspelled_CONFIG_variables
>> and
>> http://www.fsdev.net/wiki/index.php?title=Dead_CONFIG_variables
>> ?
> 
> They are the same, but they do not identify the files containing the dead var.
> It may be worth to just "grep back" in kernel sources for the dead symbol to
> readd this feature, but it may be slower that way.
> 
> The difference is that since I find symbols together with file name, I cannot
> use uniq but I must use that awk script.
> 
> Anyway, do we agree that a script for this should be probably
> merged in kernel sources?
> 
> Thanks for your answer.

Yes, I agree that it's useful and more convenient to be in
linux/scripts/.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
