Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYJVTZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYJVTZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYJVTZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:25:49 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:63162 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbYJVTZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j15YZo/WavqzTwsyIMeySUJHWn6QYT2y5W1AWLGEboMuwB2pwtSksOIV/NH/3n1Y2X
         TfYPABlkhoSgU8yvQIRrrO8i/McbsHKwSKUlkuhtLDE460Minnp8DWmoUETO7xW5tfqf
         VvjgkXAWm5qJ4y43V2i8SMBg1RJFaxQjnKo5w=
Message-ID: <b637ec0b0810221225q589ed071i75f559d6fa76d96b@mail.gmail.com>
Date: Wed, 22 Oct 2008 21:25:46 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: Possible bug in SCSI Kconfig
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <1224702340.6851.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
	 <1224702340.6851.20.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Oct 22, 2008 at 9:05 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2008-10-22 at 18:29 +0200, Fabio Comolli wrote:
>> Hi.
>> In kernel 2.6.27.2 - drivers/scsi/Kconfig we have:
>>
>> config SCSI_WAIT_SCAN
>>         tristate
>>         default m
>>         depends on SCSI
>>         depends on MODULES
>>
>> The tristate field is empty. This has the effect that this option is
>> not visible in menuconfig and so it's always selected. The default is
>> "m" for all architectures and so this module is always compiled if
>> SCSI and MODULES are both enabled.
>>
>> I'm using a patch like this one:
>>
>>  config SCSI_WAIT_SCAN
>> -     tristate
>> +     tristate "Wait until all the async scans are complete"
>>       default m
>>       depends on SCSI
>>       depends on MODULES
>>
>> to get rid of that module.
>>
>> Of course, I have no idea if this is correct or the current behavior
>> is the expected one.
>
> The point of all of this is that if you enable async scanning, you need
> a method of waiting for the scans to complete, which is all this module
> does (you insert it and it doesn't come back from the insertion until
> all the pending async scans are complete).  It's tristate because really
> it only makes sense to be M or N.  The consensus is that, given async
> scanning is always an option, this function should always be built as a
> module *if* modules and SCSI are enabled ... because you might have a
> HBA module you enabled async scanning for and you need to wait.

OK, I see your point.

But in my case I have SCSI enabled only because it's SELECTed by ATA
(it's just a laptop) and I don't have any hba's and never will. So no
async scan.

Maybe this module should be enabled if async scan is.

>
> There's really not much point giving the user the choice, since this
> module is part of the initrd sequence ... it's not really anything a
> user would want to use stand alone, hence there's no point giving a
> choice about it.
>

I don't use initrd at all. I just noticed the existence of this module
while trying to have a non modular kernel. This failed because of
ipw2200 and after having enabled modules again I just found this
scsi_wait_scan.ko.

> James
>
>
>

Regards,
Fabio
