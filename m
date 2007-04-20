Return-Path: <linux-kernel-owner+w=401wt.eu-S1767073AbXDTMPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767073AbXDTMPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767074AbXDTMPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:15:19 -0400
Received: from smtpauth12.prod.mesa1.secureserver.net ([64.202.165.35]:36331
	"HELO smtpauth12.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767072AbXDTMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:15:17 -0400
Message-ID: <4628AED3.9080203@seclark.us>
Date: Fri, 20 Apr 2007 08:15:15 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, 7eggert@gmx.de,
       emisca <emisca.ml@gmail.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it>	<88Sov-662-3@gated-at.bofh.it>	<88SHV-6uL-29@gated-at.bofh.it>	<8agVk-3wc-81@gated-at.bofh.it>	<8b3IR-4mE-25@gated-at.bofh.it>	<8b3SA-4z3-5@gated-at.bofh.it>	<8b42g-51N-15@gated-at.bofh.it>	<8bbdm-7iS-27@gated-at.bofh.it>	<E1He8dA-0000mw-LI@be1.lrz>	<46260981.1040109@gmail.com>	<20070418132904.3322ba5f@the-village.bc.nu>	<46261337.3010406@gmail.com>	<20070418140346.636879a1@the-village.bc.nu>	<46262C0E.9000103@rtr.ca> <20070418160627.7ab77c30@the-village.bc.nu> <46263650.3080705@rtr.ca> <46263859.2060309@gmail.com> <46265089.4000409@rtr.ca> <46265307.7060405@rtr.ca> <4626596E.4040304@seclark.us> <4627ABE9.8090906@redhat.com>
In-Reply-To: <4627ABE9.8090906@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:

>Stephen Clark wrote:
>  
>
>>Mark Lord wrote:
>>
>>    
>>
>>>Mark Lord wrote:
>>> 
>>>
>>>      
>>>
>>>>With the patch applied, I don't see *any* new activity in those
>>>>S.M.A.R.T.
>>>>attributes over multiple hibernates (Linux "suspend-to-disk").
>>>>  
>>>>        
>>>>
>>>Scratch that -- operator failure.  ;)
>>>The patch makes no difference over hibernates in the SMART logs.
>>>
>>>It's still logging extra Power-Off_Retract_Count pegs,
>>>which it DID NOT USED TO DO not so long ago.
>>>
>>>Now I'll poke at the shutdown again.
>>>
>>>Meanwhile, Stephen:  Could you try without this line in the patched file:
>>>
>>>       case ATA_16:
>>>+               dev->needs_sync_cache = 1;
>>>
>>>Ie. comment out that last "dev->needs_sync_cache" line.
>>>
>>>
>>>      
>>>
>>No joy - even with that line commented out I get a click and my
>>Power-Off_Retract_Count has incremented.
>>
>>    
>>
>
>I found a solution of sorts on Fedora 6:
>
>
>Edit /etc/rc0.d/S01halt, changing the third-from-last line so it reads:
>
>HALTARGS="-d -h -n"
>
>Then use the halt(8) command to shut down and turn off the power manually.
>No click and the "retract" counter does not increment. (Even this procedure
>incremented the counter until I changed the script.)
>
>Seems safe, using the IDE drivers, since they sync the cache anyway.
>
>
>  
>
Hi Chuck,

I got a chance to try this and it works for me also. No pop and my 
retract counter does not increment.

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



