Return-Path: <linux-kernel-owner+w=401wt.eu-S1766916AbXDSRxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766916AbXDSRxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766914AbXDSRxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:53:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766909AbXDSRw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:52:59 -0400
Message-ID: <4627ABE9.8090906@redhat.com>
Date: Thu, 19 Apr 2007 13:50:33 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Stephen.Clark@seclark.us
CC: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, 7eggert@gmx.de,
       emisca <emisca.ml@gmail.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it>	<88Sov-662-3@gated-at.bofh.it>	<88SHV-6uL-29@gated-at.bofh.it>	<8agVk-3wc-81@gated-at.bofh.it>	<8b3IR-4mE-25@gated-at.bofh.it>	<8b3SA-4z3-5@gated-at.bofh.it>	<8b42g-51N-15@gated-at.bofh.it>	<8bbdm-7iS-27@gated-at.bofh.it>	<E1He8dA-0000mw-LI@be1.lrz>	<46260981.1040109@gmail.com>	<20070418132904.3322ba5f@the-village.bc.nu>	<46261337.3010406@gmail.com>	<20070418140346.636879a1@the-village.bc.nu>	<46262C0E.9000103@rtr.ca> <20070418160627.7ab77c30@the-village.bc.nu> <46263650.3080705@rtr.ca> <46263859.2060309@gmail.com> <46265089.4000409@rtr.ca> <46265307.7060405@rtr.ca> <4626596E.4040304@seclark.us>
In-Reply-To: <4626596E.4040304@seclark.us>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
> Mark Lord wrote:
> 
>> Mark Lord wrote:
>>  
>>
>>> With the patch applied, I don't see *any* new activity in those
>>> S.M.A.R.T.
>>> attributes over multiple hibernates (Linux "suspend-to-disk").
>>>   
>>
>> Scratch that -- operator failure.  ;)
>> The patch makes no difference over hibernates in the SMART logs.
>>
>> It's still logging extra Power-Off_Retract_Count pegs,
>> which it DID NOT USED TO DO not so long ago.
>>
>> Now I'll poke at the shutdown again.
>>
>> Meanwhile, Stephen:  Could you try without this line in the patched file:
>>
>>        case ATA_16:
>> +               dev->needs_sync_cache = 1;
>>
>> Ie. comment out that last "dev->needs_sync_cache" line.
>>
>>
> No joy - even with that line commented out I get a click and my
> Power-Off_Retract_Count has incremented.
> 

I found a solution of sorts on Fedora 6:


Edit /etc/rc0.d/S01halt, changing the third-from-last line so it reads:

HALTARGS="-d -h -n"

Then use the halt(8) command to shut down and turn off the power manually.
No click and the "retract" counter does not increment. (Even this procedure
incremented the counter until I changed the script.)

Seems safe, using the IDE drivers, since they sync the cache anyway.

