Return-Path: <linux-kernel-owner+w=401wt.eu-S1751295AbZGUXvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbZGUXvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbZGUXvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:51:20 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:37593 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZGUXvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:51:19 -0400
Message-ID: <4A665442.1010006@caviumnetworks.com>
Date: Tue, 21 Jul 2009 16:50:26 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Matt Mackall <mpm@selenic.com>, linux-embedded@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       David Woodhouse <dwmw2@infradead.org>, Tim Bird <tim.bird@am.sony.com>
Subject: Re: [RFC] move __devinit or __init printk constant format strings
 to __devinitconst or __initdata?
References: <1248211253.31365.337.camel@Joe-Laptop.home>	 <1248212925.10466.143.camel@calx>	 <1248213403.31365.343.camel@Joe-Laptop.home>	 <1248217044.10466.202.camel@calx> <1248217502.31365.381.camel@Joe-Laptop.home>
In-Reply-To: <1248217502.31365.381.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jul 2009 23:50:27.0317 (UTC) FILETIME=[05C04250:01CA0A5E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Tue, 2009-07-21 at 17:57 -0500, Matt Mackall wrote:
>> On Tue, 2009-07-21 at 14:56 -0700, Joe Perches wrote:
>>> On Tue, 2009-07-21 at 16:48 -0500, Matt Mackall wrote:
>>>> On Tue, 2009-07-21 at 14:20 -0700, Joe Perches wrote:
>>>>> Is moving constant string formats to __devinitconst or __initdata
>>>>> useful for embedded environments?
>>>> Interesting notion, but not worth the trouble in my mind. I think it's
>>>> more worthwhile to look into automatic such stuff in the build somehow.
>>> I think it's not possible today to get gcc to mark
>>> the format strings without source modification.
>> Yep, that's why I specifically said 'build'. It can probably be done in
>> a post-processing step with some ELF wizardry. 
> 
> Know any elven wizards?
> 

It would be tricky, the string data from the entire compilation unit is 
intermingled.  You would have to separate out only those strings 
referenced from __init sections into their own section and fix up all 
symbols and relocations that were affected.

Probably easier would be to use the plug-in feature that will be part of 
GCC-4.5 (or will that be called GCC-5.0??), and create a special Linux 
kernel GCC plug-in that just emits the __init literal strings to the 
proper section to begin with.  This wouldn't be unprecedented, the 
Mozilla people already use their own extensions to GCC, and will 
probably migrate to GCC plug-ins.  We don't want the kernel to get left 
behind in the GCC plug-in race.

David Daney
