Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbYIUQA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbYIUQA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 12:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYIUQAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 12:00:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:26019 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbYIUQAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 12:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MY6nYRyXglrqCCdyDL3pE6JcKDdJPYHD1DHLlZoX5qrldGswWHQzDU+B2aUF0vbJ8v
         iwif4Qfq2DxPEhP0fde2Ob3I5xTDXhTTLt8E3+ihMaE4qItI7EhpA/1HHinf7dJHXOXV
         PBieo3cg616iyvo5255kRYgRQ3BXGuddagGbA=
Message-ID: <48D66F9C.4000204@gmail.com>
Date: Sun, 21 Sep 2008 19:00:28 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: I need some serious help to debug suspend to ram problem
References: <48D4E685.8030801@gmail.com> <200809201810.45057.rjw@sisk.pl>
In-Reply-To: <200809201810.45057.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 20 of September 2008, Maxim Levitsky wrote:
>> Hi,
>>
>> I hit a dead end when trying to understand 
>> why my notebook can't resume from suspend to ram
>> if this is done two times a row.
>>
>> Single suspend/resume cycle works almost perfectly 
>> (beep that goes through the sound card is muted... 
>> no morse code for me... :-(
>>
>> )
>>
>> I compiled a minimal kernel (absolutely nothing but disk drivers, all experimental option like nohz
>> turned off)
>>
>> But I had to turn SMP, since without it system won't resume first time I suspend it.
>> (How could this affect suspend?)
> 
> It could if the system is 64-bit.  In which case please have a look at
> http://bugzilla.kernel.org/show_bug.cgi?id=11237
> 
>> With SMP and minimal kernel (of course  no closed drivers), I get same behavior,
>> first resume works second hangs.
>>
>> I then added some debug code to real mode wakeup code, I put there in first
>> place instructions, that will save some magic value to rtc (to alarm
>> registers that I know are preserved during boot cycle), and I discovered   
>> sad thing that first time bios does pass control to linux, but second time
>> (when it hangs), it doesn't. 
>>
>>
>> I tried to update bios, and I got same results.
>>
>> Of course it does work with that @#$%^& OS
> 
> So we're doing something wrong.  Please try the appended patch.
> 
>> I then proceeded to test recently posted low memory corruption patch, and
>> it did show that that @#$%^& BIOS does corrupt low memory 
>> I then reserved all low memory, but system began to hand after first suspend,
>> in exactly same way, but as expected I soon discovered, that that forces real
>> mode page to be above 1M, ok, then I reserved almost all low memory except
>> 100K window in the middle, so low allocations will work, but be placed in
>> region bios less likely to corrupt, and still that didn't help, still same hang.   
>>  

More information, I compiled kernels back to 2.6.19, and they all have exactly the same issue.


Any ideas?

Best regards,
	Maxim Levitsky
