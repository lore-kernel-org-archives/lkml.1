Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXGRTG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXGRTG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXGRTGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:06:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbXGRTGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:06:49 -0400
Message-ID: <469E6335.8010708@zytor.com>
Date: Wed, 18 Jul 2007 12:00:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718183359.GK3801@stusta.de>
In-Reply-To: <20070718183359.GK3801@stusta.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Jul 18, 2007 at 08:55:50AM -0700, H. Peter Anvin wrote:
>> Andi Kleen wrote:
>>>> Already with these patches I can compile a zImage kernel that is 450kb
>>>> large (890kb decompressed)
>>> The important part is not how big the vmlinux is, but how much
>>> memory is actually used after boot. 
>>>
>>> I expect concentrating some of the dynamic data structures would
>>> be more fruitful in fact.
>>>
>> Well, how big the vmlinux file is matters if it doesn't fit in memory
>> with enough time to get to the phase where it is dumping the init
>> sections.  *If that is not the issue*, then axing stuff like CPUID is a
>> major lose in terms of code maintainability for zero gain.
> 
> If this is an issue, then changing i386 back to discarding __exit code 
> and data at linktime instead of runtime might make a bigger difference.

What would really make a big difference would be to unspool the
initramfs in such a way that it only requires O(1) instead off O(n)
extra memory, by freeing memory as it decompresses and decodes the cpio
ball.

	-hpa
