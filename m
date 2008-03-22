Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYCVS3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYCVS3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYCVS3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:29:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53626 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYCVS3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:29:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E54FA6.3060809@s5r6.in-berlin.de>
Date: Sat, 22 Mar 2008 19:27:50 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de>
In-Reply-To: <47E540E7.7030108@m3y3r.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> Stefan Richter schrieb:
>>   - Several or all of ohci1394's MMIO reads return ~0 (all bits set
>>     to one) --- or 0 --- where different values are expected.
>>
>>   - In http://lkml.org/lkml/2008/2/23/244 we get to see a
>>     WARNING: at arch/x86/mm/ioremap.c:137 __ioremap+0xa7/0x16a()
>>     which is "WARN_ON_ONCE(page_is_ram(pfn));".
>>     After that, the failures start.
>>     But before that, "Unknown symbol" messages pop up when ohci1394
>>     is loaded.  These symbols are implemented by ieee1394 on which
>>     ohci1394 depends.
...
>> Thomas, you wrote in http://lkml.org/lkml/2008/3/17/316 that the 
>> problem resurfaced.
>>   - Are the "Unknown symbol"s still there?  These are not supposed to
>>     happen.
> No. (See explanation above).
>>   - Is the "WARNING: at arch/x86/mm/ioremap.c" still there?
> No. I couldn't reproduce this warning, yet.
> 
>>   - Can you reproduce it without the atheros driver?
> Yes.
> 
> See http://bugzilla.kernel.org/show_bug.cgi?id=10080.

Thanks.  Summary from today's bugzilla comments:
No ioremap warning, but MMIO reads still give bogus values and let 
ohci1394 fail.  ohci1394 still got the MMIO region 0x1'0000'0000 - 
0x1'0000'07ff, FWIW.  The length of the region is correct, but its 
contents bogus.
-- 
Stefan Richter
-=====-==--- --== =-==-
http://arcgraph.de/sr/
