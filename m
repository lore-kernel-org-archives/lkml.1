Return-Path: <linux-kernel-owner+w=401wt.eu-S933598AbXBXXlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbXBXXlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 18:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933600AbXBXXlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 18:41:01 -0500
Received: from terminus.zytor.com ([192.83.249.54]:47474 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933598AbXBXXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 18:41:00 -0500
Message-ID: <45E0CCFF.60407@zytor.com>
Date: Sat, 24 Feb 2007 15:40:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: dsaxena@plexity.net, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow kernel to build on Cygwin
References: <20070223034343.GA3320@plexity.net> <45DF842F.9000302@zytor.com> <Pine.LNX.4.61.0702242354550.16527@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702242354550.16527@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Feb 23 2007 16:17, H. Peter Anvin wrote:
>> Deepak Saxena wrote:
>>> diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
>>> index bea5d97..ce447ff 100644
>>> --- a/lib/gen_crc32table.c
>>> +++ b/lib/gen_crc32table.c
>>> @@ -1,6 +1,8 @@
>>> # include <stdio.h>
>>> # include "crc32defs.h"
>>> +#ifndef __CYGWIN__
>>> #include <inttypes.h>
>>> +#endif
>>>
>>> #define ENTRIES_PER_LINE 4
>> Cygwin has <inttypes.h> just fine; what are you trying to do here?
> 
> What's the benefit of inttypes.h over stdint.h?
> 

<inttypes.h> is a superset of <stdint.h>; some older platforms don't 
have <stdint.h> (but has all the contents thereof in <inttypes.h>) however.

In general <inttypes.h> is what you want.  The utility of <stdint.h> is 
relatively limited; it looks like it's intended so that <stdint.h> 
contains the compiler-specific portions rather than the library-specific 
portions.

	-hpa
