Return-Path: <linux-kernel-owner+w=401wt.eu-S1759558AbXIMPFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbXIMPFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXIMPFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:05:48 -0400
Received: from ox.emgs.com ([194.248.190.99]:52653 "EHLO ox.emgs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbXIMPFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:05:48 -0400
Message-ID: <46E951C6.1000403@pvv.org>
Date: Thu, 13 Sep 2007 17:05:42 +0200
From: Jon Ivar Rykkelid <jonry@pvv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46E94728.9050509@garzik.org>
In-Reply-To: <46E94728.9050509@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jon Ivar Rykkelid wrote:
>>
>> Hi, I'm resending (didn't see my first attempt appear on the maillist):
>>
>>
>>
>> I'm having serious disk-issues when using the on-board nvidia controller
>> for my HDDs (My motherboard is a Gigabyte GA-N650SLI-DS4 with nvidia
>> chipset, cpu is intel Core2Quad)
>>
>> excerpt from "lspci":
>> 00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
>> 00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
>> (rev a1)
>> 00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
>> (rev a1)
>>
>> I have a normal IDE/P-ATA-disk attached to the "IDE"-controller and that
>> works fine (/dev/hda)
>>
>> However, any number of disks (I have tried 2 and 4) connected to the
>> SATA-controller(s), will eventually fail. - See attached log (excerpt /
>> anything relevant from /var/log/messages)
>>
>> At first, disks were REALLY unstable, but then I disabled S.M.A.R.T.
>> (both in BIOS and Linux), and I updated from the CentOS5 (equivalent of
>> RHEL5) kernel (2.6.18) to the latest (at that time) official kernel from
>> kernel.org:
>>
>>  > uname -a
>> Linux mirakel 2.6.22.5-custom_jir #2 SMP Thu Aug 30 22:06:21 CEST 2007
>> i686 i686 i386 GNU/Linux
>>
>> Now it will normally take a day or two before SATA crashes, so things
>> are better, but still rather useless.
>>
>> First error when sata_nv get into problems is always:
>> "exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen"
>> (as shown in the attached log-file.) - when this happens to one device,
>> it'll almost instantly happen to the other disk attached to that
>> controller as well. A couple of minutes (or so) later, the disk(s)
>> connected to the other controller will start acting up as well (in the
>> same manner). - I/O freezes, and nothing helps except a reboot...
>>
>> As I run a rather large (software / md) RAID-5 disk array on this server
>> (I'm doing a bit of video editing), every crash means a time-consuming
>> rebuild of the disk-array...
>>
>> I have given up on the sata_nv / nvidia-controllers for the time being.
>> I now resort to some old PCI-connected sata-controllers which work fine
>> (but slow, as they are outdated and "overloaded").
>>
>> So, if anyone has a good solution / suggestion / improved driver (over
>> the one supplied with the official 2.6.22.5-kernel) I am eager to give
>> it a go and see if the situation can be resolved.
>
> does adma=0 module option do anything?
>
>     Jeff
Thanks for the suggestion, but sata_nv is not built modular in my 
current kernel, so "no can do" at the moment
(However, if some expert REALLY thinks this will fix things, I will 
CERTAINLY recompile and give it a go)

As I said before, it all works for some time (a day or two) before it 
crashes with the current kernel & no "S.M.A.R.T.". With my current setup 
I have always had the time to fully rebuild my disk-array before a new 
crash. - In the case of 4 disks attached to the nvidia controllers 
(disregarding the disks on other controllers), this means that the 
sata_nv-driver / controllers alone have read at least 750GB and written 
250GB of data before the crash (with no resets working) - soft reboot 
fixes everything. -  I'm pretty confident that this is a driver issue.

As Tejun Heo <htejun@gmail.com> writes "the whole controller seems to 
have went down at once and it's not even IRQ routing problem - resets 
are failing."

The error-messages / crash-symptoms were the same with SMART enabled and 
the original CentOS5-kernel, except that with that setup, the crashes 
were much more frequent.

Any help?

BR
Jon Ivar

