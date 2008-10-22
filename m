Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYJVTaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYJVTaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbYJVT3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:29:41 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46172 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321AbYJVT3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oYj10ZHSGJE6mbXW24e5LunH3xpm0QSE40ymPIlSLGx5B1lEq/Oyba1dikujNTTS+R
         Vs4v5q4wdT4kPkeaKYSkxr1sKPWlh0jvcUQTl4dLxCWjLTpNcTUhPXHMrYaR+L6VF9Nh
         FJe0/++wZbSuWE+KN9wMCjSLuI4iuifDgmfIo=
Message-ID: <b637ec0b0810221229n636ef47er78f119617ef93085@mail.gmail.com>
Date: Wed, 22 Oct 2008 21:29:37 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Possible bug in SCSI Kconfig
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, "Matthew Wilcox" <matthew@wil.cx>
In-Reply-To: <48FF726D.9060504@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
	 <48FF726D.9060504@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Oct 22, 2008 at 8:35 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> (adding Cc: LSML and author)
>
> On 10/22/2008, Fabio Comolli wrote at LKML:
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
>>
>> Regards,
>> Fabio
>
> What's the correct behaviour is contentious.  There have been complaints
> that it shouldn't be built if it is not needed.  However, how it
> currently works is how those who added and merged that feature thought
> that it should be.
>
> Notes on your suggestion:
>
>  - If you make it a visible prompt, you should also add a help text.
>    No Kconfig prompts without good help text, please!
>
>  - The suggested prompt text doesn't describe the matter too well.
>    scsi_wait_scan rather is a module which userland can use to get
>    a signal for when scans (by some but not all transports) are done.
>    (The signal is the end of module initialization of the
>    scsi_wait_scan module.)  I.e. the kernel as a whole doesn't
>    necessarily wait, just this module does.
>

Well, I didn't mean to have the patch merged. My point was just to
understand if the Kconfig was correct.

> You could use the comment in drivers/scsi/scsi_wait_scan.c and the
> changelog of
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3e082a910d217b2e7b186077ebf5a1126a68c62f
> as a basis for the Kconfig help text.  You could actually add a help
> text even to invisible prompts, just for documentation purposes.

Well, the first line of comment in that file reads "This is a simple
module to wait until all the async scans are complete." More or less
the text I added to the tristate.

> --
> Stefan Richter
> -=====-==--- =-=- =-==-
> http://arcgraph.de/sr/
>

Regards,
Fabio
