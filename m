Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0BDJKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:10:23 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:54759 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab0BDJKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:10:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vy8LR9rHk4sIvRJk7X9JLabnwAsmWUh02O79uaYdexsW8nVb15x1smFXG83FQl1VUU
         x/i6WK3wKWssEZLtxbOvFXBsI1LXPK89ua/5e0+kBYMNdljqk2cNU6mPhlVfg99RsiTX
         VHmqRAvz4cKpByPKqFzBhau3C5TeiXaSQLFmk=
Message-ID: <4B6A8DA9.4090804@gmail.com>
Date: Thu, 04 Feb 2010 01:04:41 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Dan Carpenter <error27@gmail.com>,
       bernhard.kaindl@gmx.net, Thomas Gleixner <tglx@linutronix.de>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Rafael Wysocki <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebiderman@xmission.com, hpa@zytor.com
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug	 #14487]
 PANIC: early exception 08 rip 246:10 error	 ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com> <4B67CC55.40301@s5r6.in-berlin.de> <4B67CCEC.2030103@s5r6.in-berlin.de> <4B68D4CA.2010803@gmail.com> <4B694D5C020000780002D6DA@vpn.id2.novell.com> <4B6A0123.3010607@gmail.com> <4B6A9960020000780002DA6B@vpn.id2.novell.com>
In-Reply-To: <4B6A9960020000780002DA6B@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/10 00:54, Jan Beulich wrote:
>>>> "Justin P. Mattock"<justinmattock@gmail.com>  04.02.10 00:05>>>
>> [   0.000000] 0100000000 - 0140000000 page 2M
>> [   0.000000] kernel direct mapping tables up to 140000000 @ b000-11000
>> [   0.000000] init_ohci1394_dma: initializing OHCI-1394 at 05:00.0
>> [   0.000000] bootmem alloc of 4096 bytes failed!
>> [   0.000000] Kernel panic - not syncing: Out of memory
>> [   0.000000] Pid: 0, comm: swapper Not tainted
>> 2.6.33-rc6-00072-gab65832 # 39
>> [   0.000000] Call Trace:
>>
>> then the rest shown on the picture on the bug report.
>>
>> Out of memory?
>
> bootmem allocation before bootmem was even initialized. And that's
> likely because the code tries to populate the pmd that (due to the
> issue explained yesterday) isn't statically initialized.
>
> Jan
>
>

I'll have a look at this in the morning(late over here),
but one thing I'm seeing is the device numbers:
the error shows 05:00.0 while on a good go
of this I saw the address at **3** something(can grab
the info later for you).

which probably goes to what you are saying:
tries to populate the pmd

a quick google on this showed somewhere
at bootmem.c any ideas on this or where
this might be caused besides fixmap?
(or is fixmap the main location?);


Justin P. Mattock
