Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYFLH6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYFLH6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 03:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbYFLH6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 03:58:46 -0400
Received: from smtp-out-4.talktalk.net ([62.24.128.234]:9805 "EHLO
	smtp.talktalk.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754187AbYFLH6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 03:58:46 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2008 03:58:45 EDT
X-Path: TTSMTP
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoI/ABpxUEhZ8DRsPGdsb2JhbACIaYkpAQEBAS2ecg
Date: Thu, 12 Jun 2008 08:48:22 +0100 (BST)
From: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
X-X-Sender: tigran@ginsburg.homenet
To: Giacomo Catenazzi <cate@debian.org>
cc: Dave Jones <davej@redhat.com>, Ben Castricum <lk0806@bencastricum.nl>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [patch] x86: microcode: Cosmetic changes
In-Reply-To: <4850B9AA.7030004@debian.org>
Message-ID: <Pine.LNX.4.61.0806120844001.20771@ginsburg.homenet>
References: <alpine.LNX.1.10.0806101312170.14868@gateway.bencastricum.nl>
 <20080611170939.GA15146@redhat.com> <4850B9AA.7030004@debian.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Giacomo Catenazzi wrote:
> Dave Jones wrote:
>> On Tue, Jun 10, 2008 at 01:15:12PM +0200, Ben Castricum wrote:
>> > @@ -805,6 +806,9 @@ static int __init microcode_init (void)
>> >  {
>> >  	int error;
>> >
>> > +	printk(KERN_INFO
>> > +		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
>> > +
>> >  	error = microcode_dev_init();
>> >  	if (error)
>> >  		return error;
>> > @@ -825,9 +829,6 @@ static int __init microcode_init (void)
>> >  	}
>> >
>> >  	register_hotcpu_notifier(&mc_cpu_notifier);
>> > -
>> > -	printk(KERN_INFO
>> > -		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
>> >  	return 0;
>>
>> By doing this before the registration of the sysdev, we'll
>> now be printing this on machines that don't have the microcode
>> update facility.   Pointless spew, for no obvious gain imo.
>>
>> [Why we go through so many hoops before we check if the CPU is
>>  capable is a mystery to me. It would make more sense to have
>>  that be the first thing that gets checked when this inits]
>
> I would remove the printk:
> - it is the only email on my dmesg, along two other copyright
>  notices (Ingo and Intel). So it seems that the dmesg clean-up
>  is going on.
> - the code of driver is stable, and now it is updated only in
>  kernel trees, so IMO it is better to use kernel version on
>  bug report. BTW I don't think people will update the version
>  number of driver.
> - IMO it is enough to printk the microcode loads, not the
>  driver load.

I would prefer Dave's suggestion, i.e. doing the printk after the 
initialization.

Btw, it is not the only email, you forgot the "root@<localmachine>" in the 
kernel utsname printout :)

$ dmesg | grep @
Linux version 2.6.24.4 (root@elpis) (gcc version 4.1.1 20061011 (Red Hat 4.1.1-30)) #1 SMP Thu Mar 27 17:24:19 GMT 2008

If you want so much to remove something you may remove my email address 
from the printk, but please leave the basic message about driver loading. 
This way we know that the driver initialized itself and loaded 
successfully.

Kind regards
Tigran
