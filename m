Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbZI2IZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbZI2IZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 04:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZI2IZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 04:25:39 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:55633 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752830AbZI2IZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 04:25:39 -0400
Message-ID: <4AC1C483.3000308@suse.de>
Date: Tue, 29 Sep 2009 12:25:39 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Thomas Backlund <tmb@mandriva.org>
CC: Len Brown <lenb@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [git pull request] ACPI & driver patches for Linux-2.6.32-rc0
References: <alpine.LFD.2.00.0909190237560.22030@localhost.localdomain> <4ABCB2CA.4020709@mandriva.org> <d3f22a0909261902o5e48c2a0lab56fca21edf8c5b@mail.gmail.com> <1254016503.17697.21.camel@minggr.sh.intel.com> <alpine.LFD.2.00.0909270348570.16783@localhost.localdomain> <4AC11A0F.2030806@mandriva.org> <4AC12015.4040508@suse.de> <4AC12B4D.30508@mandriva.org> <4AC12E51.8050501@mandriva.org> <4AC134EB.1050705@suse.de> <4AC15582.8090601@mandriva.org>
In-Reply-To: <4AC15582.8090601@mandriva.org>
Content-Type: multipart/mixed;
 boundary="------------080508040400060009050505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080508040400060009050505
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Thomas Backlund пишет:
> Alexey Starikovskiy wrote:
>> Thomas Backlund пишет:
>>> Thomas Backlund wrote:
>>>> Alexey Starikovskiy wrote:
>>>>> Thomas Backlund пишет:
>>>>>> Now this is a Acer TravelMate 5720G laptop with the latest 1.35 bios.
>>>>>> Distro is Mandriva Linux Cooker, and arch is x86_64
>>>>>>
>>>>>> Attached is output of "grep ACPI /var/log/dmesg"
>>>>>> dmesg-acpi-20090903
>>>>>> - all acpi patches as of 2.6.32-rc1
>>>>> This one does not have errors you've mentioned earlier, could you 
>>>>> find dmesg with them?
>>>> Ah, sorry about that...
>>>> I should have done dmesg|grep ACPI to get the errors... it would 
>>>> have shown this too:
>>>> tg3 0000:02:00.0: wake-up capability disabled by ACPI
>>>> ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] 
>>>> (20090903/evregion-424)
>>>> ACPI Error (psparse-0537): Method parse/execution failed 
>>>> [\_SB_.PCI0.LPCB.EC0_.GBST] (Node ffff88013f81c5e0), AE_TIME
>>>> ACPI Error (psparse-0537): Method parse/execution failed 
>>>> [\_SB_.PCI0.LPCB.EC0_.BAT0._BST] (Node ffff88013f81c720), AE_TIME
>>>> ACPI Exception: AE_TIME, Evaluating _BST (20090903/battery-393)
>>>>
>>>>
>>>>
>>>>>> dmesg-acpi-20090903-ec-2.6.31
>>>>>> - all acpi patches as of 2.6.32-rc1
>>>>>> - ec.c from 2.6.31.1
>>>>>>
>>>>>>
>>>>>> Should I start bisecting, or do you have any other suggestion?
>>>>> There is only one patch which touch ec.c, 
>>>>> 2a84cb9852f52c0cd1c48bca41a8792d44ad06cc. You may try to revert it, 
>>>>> and see.
>>>>>
>>>> Isn't that what pretty much what I did when I built a kernel with 
>>>> the 2.6.31.1 ec.c ?
>>>>
>>>> Anyway, after I applied your patch you just posted on acpi-devel:
>>>> ACPI: EC: Rewrite DMI checks
>>>>
>>>> to the 2.6.32-rc1 tree the:
>>>>
>>>>> -ACPI Error (psargs-0359): [\_PR_.CPU0.CSTX] Namespace lookup 
>>>>> failure, AE_NOT_FOUND
>>>>> -ACPI Error (psparse-0537): Method parse/execution failed 
>>>>> [\_SB_.PCI0.LPCB.EC0_._Q2F] (Node ffff88013f81c1a0), AE_NOT_FOUND
>>>> does not show up at boot anymore, and so far I haven't seen the 
>>>> other errors either...
>>>>
>>>> I'll post a follow-up if they show up again...
>>>>
>>> Bah...
>>> I spoke too soon:
>>>
>> Could you please turn on timing information in printk ? Please also 
>> uncomment "#define DEBUG" in ec.c
>>
> 
> That generated a big log......
> 
> This is now grep ACPI /var/log/syslog from the 2.6.32-rc1 + the above 
> "ACPI: EC: Rewrite DMI checks"
> 
> As it's big, I posted it here:
> http://tmb.mine.nu/acpi-ec-bug/acpi-ec-debug.bz2
Thanks,
please check if attached patch helps:
> 
> -- 
> Thomas


--------------080508040400060009050505
Content-Type: text/x-diff;
 name="reset-controller.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reset-controller.patch"

ACPI: EC: Restart command even if no interrupts from EC

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/ec.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)


diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index da7da37..9c34515 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -234,10 +234,8 @@ static int ec_poll(struct acpi_ec *ec)
 			}
 			advance_transaction(ec, acpi_ec_read_status(ec));
 		} while (time_before(jiffies, delay));
-		if (!ec->curr->irq_count ||
-		    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF))
+		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF)
 			break;
-		/* try restart command if we get any false interrupts */
 		pr_debug(PREFIX "controller reset, restart transaction\n");
 		spin_lock_irqsave(&ec->curr_lock, flags);
 		start_transaction(ec);

--------------080508040400060009050505--
