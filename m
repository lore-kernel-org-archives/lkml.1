Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbZLOCMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbZLOCMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758433AbZLOCL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:11:58 -0500
Received: from ns.netcenter.hu ([195.228.254.57]:53143 "EHLO mail.netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbZLOCL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:11:57 -0500
X-Greylist: delayed 2944 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2009 21:11:57 EST
Message-ID: <369401ca7d25$0045b230$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
To: "Robert Hancock" <hancockrwd@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
References: <315c01ca7ca7$641ff8c0$0400a8c0@dcccs> <4B26E03E.5050309@gmail.com>
Subject: Re: HDD power up in standby
Date: Tue, 15 Dec 2009 02:21:58 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

----- Original Message ----- 
From: "Robert Hancock" <hancockrwd@gmail.com>
To: "Janos Haar" <djani22@netcenter.hu>
Cc: <linux-kernel@vger.kernel.org>
Sent: Tuesday, December 15, 2009 2:02 AM
Subject: Re: HDD power up in standby


> On 12/14/2009 04:22 AM, Janos Haar wrote:
>> Hello list,
>>
>> I have posted to the common, because this theme is for more lists (ide,
>> sata, scsi), i think....
>>
>> I know you will not like me guys, but i have one wish.... :-)
>>
>> I am building cheap but big storages, and after 12 drive / PC i have 
>> faced
>> with one problem:
>> The too much spinup current wich made by the 12-16 drive at the same 
>> time.
>> In my actual case, in 12V, there is more than 2A / drive for some 
>> seconds.
>>
>> I know, in SCSI, there is a jumper for this, and the card can wake up the
>> drives one by one, but i am using 2TB drives, and in SCSI/SAS this have
>> horrible price...
>> I have done some invesrtigation, and found this:
>> The most of the simple sata drives handles the PUIS mode (by set
>> features ata command), but unfortunately
>> only the professional and expensive raid cards supports the wakeing up.
>> If the cheap cards founds only 0 byte drives, this is not a problem at 
>> all,
>> because linux usually not use BIOS support fortunately. :-)
>> But i have found when i have spent a little time in google, and in the
>> documentation, linux doesn't support PUIS.
>>
>> I think this would be great, and (relatively) simple to implement this
>> feature.
>> I can imagine in this way:
>> Wake up from PUIS is disabled by default, but can be enabled by command
>> line
>> parameter, or compile time configuration.
>> The drivers should send the wake up command one by one to the drives, 
>> waits
>> for RDY DSC, and than scan the drives, and register....
>>
>> What do you think?
>
> As far as I can see, if the drive reports it's in power-up in standby mode 
> from the identify response, the kernel will send the command to spin up 
> the drive. It might depend on whether parallel scan is enabled for the 
> controller as far as whether they actually spin up one at a time, however.

I am working with 2TB Hitachi drive wich is set to PUIS, and reports itself 
as 0 byte, but existing device (pcb factory alias), but with my promise 
card, the kernel see only bad geometry and disable the port only. :-(
I have missed something?

>
>>
>> (Now i am searching for the solution to send the wakeup command by user
>> program, and than do a "hotplug" in software only, but this is not an
>> "elegant" solution...)
>>
>>
>> Best Regards,
>> Janos Haar
>> 

