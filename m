Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYBHVFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYBHVFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758491AbYBHVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:03:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758911AbYBHVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:03:38 -0500
Message-ID: <47ACC381.9070601@zytor.com>
Date: Fri, 08 Feb 2008 13:02:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <47AB975C.1010902@zytor.com> <20080208070419.GA4544@ucw.cz> <200802081723.16354.rjw@sisk.pl> <20080208210004.GA12923@elf.ucw.cz>
In-Reply-To: <20080208210004.GA12923@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Fri 2008-02-08 17:23:15, Rafael J. Wysocki wrote:
>> On Friday, 8 of February 2008, Pavel Machek wrote:
>>> Hi!
>> Hi,
>>
>>>>> I really need the entry point to be at offset 0, so 
>>>>> that I can get
>>>>> pointers to my data. I could not figure out how to do 
>>>>> it any other
>>>>> way. And if 0 is taken, I thought I'd put header at the 
>>>>> end.
>>>>>
>>>> Why not just put the structure at 0, and put pointers in 
>>>> the structure to everything else you need?
>>> segments:offsets rear its ugly head here. I need %ds to point to my
>>> data, and the way to do it is copy it from %cs; that needs start to be
>>> at 0.
>> Hm, why exactly is that necessay?
> 
> It is not _neccessary_. Try to come up with another method that gets
> relocations right. I could not :-(.
> 
> (Actually, putting table at the offset 0 and short jump at beggining
> of the table would probably do the trick. But that still keeps code at
> offset 0 :-).
> 									Pavel

Why not just put a pointer to the start of the code in the table, and 
make an indirect call to it?

Where is this code?

	-hpa
