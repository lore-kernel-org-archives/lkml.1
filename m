Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYITMDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYITMDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 08:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYITMD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 08:03:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:50162 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYITMD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 08:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=rgf8xuhBk4u3SFykMii8cY8LjRAqRjAFIaxESb99OGaKpfFLMV7jBeFqY+NxO2J0Eb
         ayAiAH6aCwIyrSQN9BxMO2+yhLyMczVQR4MmPpyWEtjyAbLt5jJdCY4Bz818R3w8JPu+
         P4bq2E2LyXILcaIgdQbRHMj4qwbzf3kMVTrVo=
Message-ID: <48D4E685.8030801@gmail.com>
Date: Sat, 20 Sep 2008 15:03:17 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: I need some serious help to debug suspend to ram problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hit a dead end when trying to understand 
why my notebook can't resume from suspend to ram
if this is done two times a row.

Single suspend/resume cycle works almost perfectly 
(beep that goes through the sound card is muted... 
no morse code for me... :-(

)

I compiled a minimal kernel (absolutely nothing but disk drivers, all experimental option like nohz
turned off)

But I had to turn SMP, since without it system won't resume first time I suspend it.
(How could this affect suspend?)


With SMP and minimal kernel (of course  no closed drivers), I get same behavior, first resume works
second hangs.

I then added some debug code to real mode wakeup code, I put there in first place instructions, that will save some magic value to rtc (to alarm registers that I know are preserved during boot cycle), and I discovered 
sad thing that first time bios does pass control to linux, but second time (when it hangs), it doesn't.


I tried to update bios, and I got same results.

Of course it does work with that @#$%^& OS


I then proceeded to test recently posted low memory corruption patch, and it did show that that @#$%^& BIOS does corrupt low memory
I then reserved all low memory, but system began to hand after first suspend, in exactly same way, but as expected I soon discovered,
that that forces real mode page to be above 1M, ok, then I reserved almost all low memory except 100K window in the middle, so low allocations will work, but be placed in region bios less likely to corrupt, and still that didn't help, still same hang.


You did face lot of such situations, so maybe you know about anything I can do.

System is ACER aspire 5720G.

I now use 2.6.27-rc5, but same did happen on 2.6.26, and if I remember correctly 2.6.25.
(I bought this system in April and installed linux during first day)
I installed hardy there)



Note: I do use nvidia drivers, and without them display stays dark after resume, BUT, this bug is unrelated,
while screen is dark, system does work, I can see hdd led blinking when I issue commands, I can turn system off, suspend again (and get hard hang of resume...), I even stored dmesg after first suspend without nvidia driver, and there are no errors
(except that EC storm , which is harmless here (I tried  patches that fix it, but they didn't affect this suspend bug)

All tests were done without nvidia driver.

I would be very glad if you tell me any suggestions how to fix/debug that thing.

And lastly, suggestion to everybody:

NEVER BUY ACER LAPTOPS, THEY ARE JUST BROKEN

Best regards,
	Maxim Levitsky
