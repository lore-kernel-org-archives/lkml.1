Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZLTBCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZLTBCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 20:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZLTBCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 20:02:30 -0500
Received: from ns3.baby-dragons.com ([64.62.236.141]:48872 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbZLTBC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 20:02:29 -0500
Date: Sat, 19 Dec 2009 16:02:02 -0900 (AKST)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Dave Hylands <dhylands@gmail.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev@vger.kernel.org,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: drivers/gpu/drm/radeon/radeon_test.c:45: undefined reference to
  `__udivdi3'
In-Reply-To: <c32efac40912190113i5292a395tcc257c16a4870f3b@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.0912191405460.12202@filesrv1.baby-dragons.com>
References: <alpine.LNX.2.01.0912181147200.9874@filesrv1.baby-dragons.com> <c32efac40912190113i5292a395tcc257c16a4870f3b@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="566704117-1884123072-1261264791=:12202"
Content-ID: <alpine.LNX.2.01.0912191421090.12202@filesrv1.baby-dragons.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (ns3.baby-dragons.com [64.62.236.141]); Sun, 20 Dec 2009 01:02:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--566704117-1884123072-1261264791=:12202
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.01.0912191421091.12202@filesrv1.baby-dragons.com>

 	Hello Dave ,

On Sat, 19 Dec 2009, Dave Hylands wrote:
> Hi Jim,
> On Fri, Dec 18, 2009 at 12:54 PM, Mr. James W. Laferriere
> <babydr@baby-dragons.com> wrote:
>>        Hello Benjamin ,  I am not having a good time compiling 2.6.32.1 .
>> First RCU 'inline' difficulties then fusion-mpt 'inline' difficulty ,  Now
>> this .
>>        This one is not a simple as removing 'inline' from a statement .
>>        Would you please look into this ?  Anything else you need please just
>> ask .
>>        Please cc: me as I am not subscribed to linux-fbdev .
>>
>>                Tia ,  JimL
>>
> ...snip...
>> drivers/built-in.o(.text+0x11345a): In function `radeon_test_moves':
>> drivers/gpu/drm/radeon/radeon_test.c:45: undefined reference to `__udivdi3'
>> make: *** [.tmp_vmlinux1] Error 1
>
> __udivdi3 is a gcc helper function used to do 64-bit division. This
> form of 64-bit division is not supported from within the kernel (which
> is why you get the undefined symbol).
>
> There is <asm/div64.h> which contains a macro called do_div which can
> perform a 64-bit dvision by a 32-bit divisor.
 	Thank you ,  For replying .  Now I being a kernel level nothing ,  How 
does this help me get past the 'ld' time undefined reference ?  So we can have 
a kernel build complete (hopefully) successfully .

 	I've another ? as well how is it that the drm/radeon_test.c is using 
(well at least referencing) a non-kernel symbol ?  That alone is rather 
interesting .

 	But all I had to do is Disable DRM in the kernel .  Since this system is 
a remote device without a real need for DRI/DRM support that should cure my 
problem .  But someone else is going to need that support & I am sure they'll 
hit that same bug .

 		Tia ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
--566704117-1884123072-1261264791=:12202--
