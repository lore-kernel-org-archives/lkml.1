Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZEWXoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZEWXoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 19:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZEWXor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 19:44:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53906 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbZEWXoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 19:44:46 -0400
Message-ID: <4A188A48.5000208@zytor.com>
Date: Sat, 23 May 2009 16:44:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Harald Welte <HaraldWelte@viatech.com>
CC: lkml@morethan.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org> <200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com> <200905231304.55973.lkml@morethan.org>
In-Reply-To: <200905231304.55973.lkml@morethan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harald,

It looks like there might be a problem with the C7-M ... Michael reports
that if he sets LOCK_PREFIX to "lock;" it works, but that shouldn't be
necessary for a uniprocessor.

I'm wondering if we have to revive the OOSTORE hack, or some other
workaround.  It is of course hard for me to track this down since (a) I
don't have access to the CPU documentation, and (b) I work for Intel
now, which limits the amount of time I can realistically spend on this.

	-hpa

[Cc: Alan, who I believed developed the OOSTORE hack back when.]


Michael S. Zick wrote:
> On Fri May 22 2009, H. Peter Anvin wrote:
>> Michael S. Zick wrote:
>>> Same integrated motherboard.
>> Which means same CPU, same BIOS, same motherboard (none of which you're
>> telling us.)
>>
>> cpuinfo and dmidecode would be informative.
>>
> 
> The -09143lk files are posted.
> 
> Download location:
> http://hp-umpc.com/ce1200v
> 
> Details so far today:
> http://forum.netbookuser.com/viewtopic.php?pid=6968#p6968
> 
> Summary:
> HP-2133 (C7-M/CN896) - 09143 - No results - Still up 3 1/2 hours.
> Cloudbook (C7-M/CX700) - 09143 - 45 minutes.
> Cloudbook (C7-M/CX700) - 09143lk - No results - Still up 1 1/2 hours.
> 
> OK - time to look for the missing "memory" in the clobber lists.  ;)
> 

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

