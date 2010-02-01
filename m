Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0BAR4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:56:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:34802 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab0BAR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:56:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=ALwcqtqstcUumKQap3L+nsYEX/HdxHJ+g2ObAFKTdy30voR6oYbbEsWwZH5vlUoYY/
         FQGbtBFEXnYb4N+PUHmLLUYg9ahBr31tieeBCnkMCmIstJgKf15r9WyGbY2bB1OQeP7X
         b5nLIMy7UbHs3DW3lsfpVR8UIXO3dcy23e4HU=
Message-ID: <4B671606.3080405@gmail.com>
Date: Mon, 01 Feb 2010 09:57:26 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error	ffffffff810251b5
 cr2 0
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker>
In-Reply-To: <20100201125441.GB2576@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/10 04:54, Dan Carpenter wrote:
> On Sun, Jan 31, 2010 at 05:39:22PM -0800, Justin P. Mattock wrote:
>> On 01/31/10 16:43, Rafael J. Wysocki wrote:
>>> This message has been generated automatically as a part of a report
>>> of regressions introduced between 2.6.31 and 2.6.32.
>>>
>>> The following bug entry is on the current list of known regressions
>>> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>>> be listed and let me know (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
>>> Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
>>> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
>>> Date		: 2009-10-23 16:45 (101 days old)
>>> References	: http://lkml.org/lkml/2009/10/23/252
>>>
>>>
>>>
>>
>>
>> yeah still hitting this.
>> looking at the issue if I change:
>>
>> @@ 260
>>
>> if ((class == 0xffffffff))
>> 	continue;
>> to
>>
>> if ((class == 0xffffffff || 0xffffffffffffffff))
>> 	continue;
>>
>
> Uh... 0xffffffffffffffff is always true so basically that's the same as deleting the
> if condition.
>
> I've added the linux1394-devel people to the CC list.
>
> Justin has found an issue that when he boots with:  ohci1394_dma=early his computer
> crashes.
>
> He can get it to boot by modifying drivers/ieee1394/init_ohci1394_dma.c:
>
> init_ohci1394_dma_on_all_controllers()
>     254          /* Poor man's PCI discovery, the only thing we can do at early boot */
>     255          for (num = 0; num<  32; num++) {
>     256                  for (slot = 0; slot<  32; slot++) {
>     257                          for (func = 0; func<  8; func++) {
>     258                                  u32 class = read_pci_config(num,slot,func,
>     259                                                          PCI_CLASS_REVISION);
>     260                                  if ((class == 0xffffffff))
>     261                                          continue; /* No device at this func */
>
> 	If he continues here then his system boots.
>
>     262
>     263                                  if (class>>8 != PCI_CLASS_SERIAL_FIREWIRE_OHCI)
>     264                                          continue; /* Not an OHCI-1394 device */
>     265
>     266                                  init_ohci1394_controller(num, slot, func);
>     267                                  break; /* Assume one controller per device */
>
> 	This comment is not terribly clear btw.  The code assumes one controller per slot.
>
>     268                          }
>     269                  }
>     270          }
>
> regards,
> dan carpenter
>
>
>> I'm able to boot, but don't have enough knowledge to know
>> what is really happening(or how to execute this).
>> will continue looking at this
>> (hopefully I get somewhere on this);
>>
>> Justin P. Mattock
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>

yeah I'll admit it, I don't know what I'm doing
(but am willing to try).

Thanks for the response, I'll try and
give as much info on this as possible.

Justin P. Mattock
